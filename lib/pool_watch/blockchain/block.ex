defmodule PoolWatch.Blockchain.Blocks do

  alias PoolWatch.Blockchain.Blocks
  alias PoolWatch.Pool.PoolInfo
  alias PoolWatch.Notification.Channels.Discord
  alias PoolWatch.Notification.Channels.Twitter

  alias PoolWatch.Notification

  defstruct [
    :epoch_no,
    :fees,
    :forged_at,
    :number,
    :op_cert,
    :size,
    :slot_in_epoch,
    :slot_no,
    :transactions_count,
    :vrf_key,
    :slot_leader
  ]

  def get_payload("DISCORD", %{"web_hook_url" => url}, %Blocks{} = b_info, %PoolInfo{} = p_info) do
    data =
      %{
        "content" => "Congratulations !!! You just recieved New Block :) ",
        "embeds" => [
          %{
            "author" => %{
              "name" => " #{p_info.name}: [#{p_info.ticker}]"
            },
            "fields" => [
              %{"name" => "Block No.", "value" => b_info.number, "inline" => true},
              %{"name" => "Epoch", "value" => b_info.epoch_no, "inline" => true},
              %{"name" => "slot", "value" => b_info.slot_in_epoch, "inline" => true},
              %{"name" => "Total Tx", "value" => b_info.transactions_count, "inline" => true},
              %{"name" => "Tx fees", "value" => b_info.fees, "inline" => true}
            ]
          }
        ]
      }

    %Discord{
      api_url: url,
      data: data
    }
  end

  def get_payload("TWITTER", info, %Blocks{} = b_info, %PoolInfo{ticker: ticker}) do
    content = ~s(#{ticker}  minted new  block: #{b_info.number} at slot: #{b_info.slot_in_epoch} $ADA #cardano #stakepool #pool_watch)

    info
    |> Map.put("content", content)
    |> Twitter.new()

  end

  def get_payload(_, _, _, _), do: nil

  def handle_block(%PoolInfo{} = pool_info, %Blocks{} = block_info, action) do
    case Notification.fetch_infos(pool_info, action) do
      [] -> nil

      infos ->
        infos
        |> Enum.map(&(parse_block(&1, pool_info, block_info)))
        |> Enum.filter(&is_map/1)
    end
  end

  defp parse_block(%{"name" => name, "info" => info}, pool_info, block_info) do
    name
    |> String.upcase()
    |> get_payload(info, block_info, pool_info)
  end

  defp parse_block(_, _, _), do: nil

  def send_request(channels) when is_list(channels) do
    channels
    |> Enum.map(&send_request/1)
  end

  def send_request(channel) when is_map(channel) do
    PoolWatch.Notification.Channels.request(channel)
  end

  def send_request(_), do: nil
end
