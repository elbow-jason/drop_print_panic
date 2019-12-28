defmodule DropPrintPanic do
  @moduledoc """
  Documentation for DropPrintPanic.
  """
  alias DropPrintPanic.Panicker
  alias DropPrintPanic.NonPanicker

  def demo(n \\ 40) do
    single_threaded_non_print_does_not_panic(n)
    single_threaded_print_does_not_panic(n)
    parallel_non_print_does_not_panic(n)
    parallel_print_panics(n)
  end

  def parallel_non_print_does_not_panic(n) do
    IO.puts("Running parallel_non_print_does_not_panic ...")
    non_panicker = NonPanicker.new("NON_PANICKER_NAME")
    ensure_name_is_binary_concurrently(non_panicker, n)
    IO.puts("Finished parallel_non_print_does_not_panic!")
  end

  def parallel_print_panics(n) do
    IO.puts("Running parallel_print_panics...")
    panicker = Panicker.new("PANICKER_NAME")
    ensure_name_is_binary_concurrently(panicker, n)
    IO.puts("Finished parallel_print_panics...THIS SHOULD NOT BE REACHED!")
  end

  def single_threaded_non_print_does_not_panic(n) do
    IO.puts("Running single_threaded_non_print_does_not_panic...")
    non_panicker = NonPanicker.new("SINGLE_THREADED_NON_PANICKER")
    ensure_name_is_binary_single_threaded(non_panicker, n)
    IO.puts("Finished single_threaded_non_print_does_not_panic!")
  end

  def single_threaded_print_does_not_panic(n) do
    IO.puts("Running single_threaded_print_does_not_panic...")
    non_panicker = NonPanicker.new("SINGLE_THREADED_NON_PANICKER")
    ensure_name_is_binary_single_threaded(non_panicker, n)
    IO.puts("Finished single_threaded_print_does_not_panic!")
  end

  defp ensure_name_is_binary_concurrently(named_item, n) do
    parent = self()
    Enum.each(1..n, fn i ->
      spawn_link(fn ->
        ensure_name_is_binary(named_item)
        if i == n do
          send(parent, :all_done)
        end
      end)
    end)
    receive do
      :all_done ->
        :ok
      after 5000 ->
        raise "SOMETHING WENT HORRIBLY WRONG :-("
    end
  end

  defp ensure_name_is_binary_single_threaded(named_item, n) do
    Enum.each(1..n, fn _i ->
      ensure_name_is_binary(named_item)
    end)
  end

  defp ensure_name_is_binary(named_item) do
    # use the item in the process just to make sure it's really there...
    name = get_name(named_item)
    if not is_binary(name) do
      raise "Name was not a binary..."
    end
  end

  defp get_name(%Panicker{} = p), do: Panicker.name(p)
  defp get_name(%NonPanicker{} = np), do: NonPanicker.name(np)
end
