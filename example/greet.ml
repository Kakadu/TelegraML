open Telegram.Api
open Telegram.Actions

module MyBot = Mk (struct

  include Telegram.BotDefaults

  let token = [%blob "../bot.token"]

  let new_chat_member {Chat.id; _} {User.first_name; _} =
    send_message ~chat_id:id "Hello, %s" first_name
end)

let () = MyBot.run ()
