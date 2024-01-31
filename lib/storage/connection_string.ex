defmodule Azure.Storage.ConnectionString do
  @moduledoc """
  Azure Storage connection string utilities.
  """

  @doc """
  Parses an Azure storage connection string into a plain map.

  Keys are normalised into lower case with underscores for convenience.
  """
  @spec parse(connection_string :: String.t()) :: map()
  def parse(connection_string) do
    connection_string
    |> String.split(";")
    |> Enum.map(&parse_connection_string_item/1)
    |> Enum.reject(fn {a, _} -> is_nil(a) end)
    |> Map.new()
  end

  defp parse_connection_string_item(item) do
    # The value part of the item can contain `=` (esp the account key which is base64-encoded), so
    # `parts: 2` is essential.
    [k, v] = item |> String.split("=", parts: 2)

    {key_for(k), v}
  end

  defp key_for("DefaultEndpointsProtocol"), do: :default_endpoints_protocol
  defp key_for("AccountName"), do: :account_name
  defp key_for("AccountKey"), do: :account_key
  defp key_for("EndpointSuffix"), do: :endpoint_suffix
  defp key_for(_), do: nil
end
