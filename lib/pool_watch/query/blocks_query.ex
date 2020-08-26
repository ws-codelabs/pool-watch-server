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

    case Neuron.query(query) do
      {:ok, %Neuron.Response{body: %{"data" => %{"blocks" => [block]}}}} ->
        block
        |> Utils.to_snake_case()

      _ ->
        []
    end
  end
end
