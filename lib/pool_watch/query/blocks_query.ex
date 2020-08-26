defmodule PoolWatch.Query.BlocksQuery do
  alias PoolWatch.Query.CommonFields
  alias PoolWatch.Utils


  def get_latest_block() do
    query = """
      {
        blocks(limit:1, where: {number: {_is_null: false}}, order_by: {number:desc}){
          #{CommonFields.block_with_stake_pool()}
        }
      }
    """

    fetch(query)

  end

  def get_block_after(block_no) when is_integer(block_no) do
    query = """
    {
      blocks(limit:1, where: {number: {_gt: #{block_no}}}){
        #{CommonFields.block_with_stake_pool()}
      }
    }
  """

  fetch(query)
  end

  defp fetch(query) do
    case Neuron.query(query) do
      {:ok, %Neuron.Response{body: %{"data" => %{"blocks" => [block]}}}} ->
        block
        |> Utils.to_snake_case()

      _ ->
        nil
    end
  end
end
