open Telegram.Api
open Telegram.Actions

module MyBot = Mk (struct
  open InlineQuery

  include Telegram.BotDefaults

  let token = [%blob "../bot.token"]
  let inline {id; query; _} =
    print_endline ("Someone said: '" ^ query ^ "'");
    let input_message_content = InputMessageContent.create_text ~message_text:query () in
    let response = InlineQuery.Out.create_article ~id:"QueryTest" ~title:"Test" ~input_message_content () in
    answer_inline_query id [response]
end)

let () = MyBot.run ()
