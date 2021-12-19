open Telegram.Api

module MyBot = Mk (struct
  open Chat
  open User
  open Command
  open Message
  open UserProfilePhotos

  include Telegram.BotDefaults

  let token = [%blob "../bot.token"]
  let command_postfix = Some "mlbot" (* Can be replaced with whatever the bot's name is, makes the bot only respond to /say_hi@mlbot *)

  let commands =
    let open Telegram.Actions in
    let say_hi {chat = {id;_};_} = Lwt.return @@ send_message ~chat_id:id "Hi"
    and my_pics = function
      | {chat; from = Some {id;_};_} ->
        get_user_profile_photos id
        /> begin function
          | Result.Success photos ->
            send_message ~chat_id:chat.id "Your photos: %d" photos.total_count
          | Result.Failure _ ->
            send_message ~chat_id:chat.id "Couldn't get your profile pictures!"
        end |> Lwt.return
      | {chat = {id;_};_} -> Lwt.return @@ send_message ~chat_id:id "Couldn't get your profile pictures!"
    and check_admin {chat = {id;_};_} =
      send_message ~chat_id:id "Congrats, you're an admin!" in
    let make_auth ~command msg = Lwt.return (with_auth ~command msg) in
    [{name = "say_hi"; description = "Say hi!"; enabled = true; run = say_hi};
     {name = "my_pics"; description = "Count profile pictures"; enabled = true; run = my_pics};
     {name = "admin"; description = "Check whether you're an admin"; enabled = true; run = make_auth ~command:check_admin}]
end)

let () = MyBot.run ()
