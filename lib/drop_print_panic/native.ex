defmodule DropPrintPanic.Native do
    use Rustler, otp_app: :drop_print_panic, crate: "dropprintpanic_native"

    defp err, do: :erlang.nif_error(:nif_not_loaded)

    def new_panicker(_name), do: err()
    def panicker_name(_p), do: err()

    def new_non_panicker(_name), do: err()
    def non_panicker_name(_np), do: err()
end
