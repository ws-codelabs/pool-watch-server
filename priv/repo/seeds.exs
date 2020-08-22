# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PoolWatch.Repo.insert!(%PoolWatch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

channels = [
  %{
    name: "Discord", logo: "fa-discord",
    inputs: [
      %{
        "label" => "WebHook Url",
        "type" => "TEXT_BOX",
        "is_required" => true,
        "key" => "web_hook_url"
      }
    ]
  },
  %{
    name: "Email", logo: "fa-envelope",
    inputs: [
      %{
        "label" => "Email Address",
        "type" => "EMAIL",
        "is_required" => true,
        "key" => "email_address"
      }
    ]
  },
  %{
    name: "Twitter", logo: "fa-twitter",
    inputs: nil
  },
  %{
    name: "Telegram", logo: "fa-telegram",
    inputs: nil
  }
]

Enum.map(channels, &PoolWatch.Channel.create_channel_info/1)
