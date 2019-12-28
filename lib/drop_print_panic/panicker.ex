defmodule DropPrintPanic.Panicker do
  alias DropPrintPanic.Native

  defstruct [:__native__]

  defdelegate new(name), to: Native, as: :new_panicker
  defdelegate name(p), to: Native, as: :panicker_name
end
