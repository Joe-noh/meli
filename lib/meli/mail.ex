defmodule Meli.Mail do
  @type t :: %Meli.Mail{}

  @struct [
    to_addresses:   [],
    to_names:       [],
    from_address:   "",
    from_name:      "",
    cc_addresses:   [],
    cc_names:       [],
    bcc_addresses:  [],
    bcc_names:      [],
    subject:        "",
    text:           "",
    html:           ""
  ]

  @keys Dict.keys(@struct)
  @binary_keys Enum.map(@keys, &Atom.to_string/1)

  defstruct @struct

  def new(params) do
    @keys
    |> Enum.zip(@binary_keys)
    |> Enum.reduce(%__MODULE__{}, fn {atom_key, bin_key}, struct ->
      case Map.get(params, bin_key) do
        nil -> struct
        val -> Map.put(struct, atom_key, val)
      end
    end)
  end

  @spec eval_eex(t, map) :: t
  def eval_eex(mail, variables) do
    Enum.reduce @keys, mail, fn key, struct ->
      Map.update!(struct, key, &do_eval_eex(&1, data: variables))
    end
  end

  defp do_eval_eex(list, binding = [data: _]) when is_list(list) do
    Enum.map(list, &EEx.eval_string(&1, binding))
  end

  defp do_eval_eex(binary, binding = [data: _]) when is_binary(binary) do
    EEx.eval_string(binary, binding)
  end
end
