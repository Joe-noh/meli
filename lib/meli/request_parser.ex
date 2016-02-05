defmodule Meli.RequestParser do

  @doc """
  This parses and transforms request parameters from end-user into Mail struct(s).
  """
  @spec parse(map) :: [Meli.Mail.t]
  def parse(params = %{"mails" => mails}) when is_list(mails) do
    common = Map.get(params, "common", %{})

    Enum.map mails, fn mail_map ->
      {variables, mail_map} = Map.pop(mail_map, "data")

      Map.merge(common, mail_map)
      |> Meli.Mail.new
      |> Meli.Mail.eval_eex(variables)
    end
  end
end
