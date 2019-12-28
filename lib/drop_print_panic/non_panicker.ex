defmodule DropPrintPanic.NonPanicker do
  alias DropPrintPanic.NonPanicker
  alias DropPrintPanic.Native

  defstruct [:__native__]

  defdelegate new(name), to: Native, as: :new_non_panicker
  defdelegate name(np), to: Native, as: :non_panicker_name
end
