defmodule Forge.Protocol.JsonRpc do
  require Logger

  @crlf "\r\n"

  def decode(message_string) do
    with {:ok, json_map} <- Jason.decode(message_string) do
      do_decode(json_map)
    end
  end

  def encode(%_proto_module{} = proto_struct) do
    with {:ok, encoded} <- Jason.encode(proto_struct) do
      encode(encoded)
    end
  end

  def encode(payload) when is_binary(payload) or is_list(payload) do
    content_length = IO.iodata_length(payload)

    json_rpc = [
      "Content-Length: ",
      to_string(content_length),
      @crlf,
      @crlf,
      payload
    ]

    {:ok, json_rpc}
  end

  # These messages appear to be empty Responses (per LSP spec) sent to
  # aknowledge Requests sent from the language server to the client.
  defp do_decode(%{"id" => _id, "result" => nil}) do
    {:error, :empty_response}
  end

  defp do_decode(%{"id" => _id, "result" => _result} = response) do
    # this is due to a client -> server message, but we can't decode it properly yet.
    # since we can't match up the response type to the message.

    {:ok, response}
  end

  defp do_decode(%{"method" => _, "id" => _id} = request) do
    GenLSP.Requests.new(request)
  end

  defp do_decode(%{"method" => _} = notification) do
    GenLSP.Notifications.new(notification)
  end
end
