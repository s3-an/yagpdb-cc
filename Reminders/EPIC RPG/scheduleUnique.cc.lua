{{/*
        Trigger for Epic RPG Reminder

	Recommended trigger: None Trigger


*/}}

{{ $msgId := (toString (sendMessageRetID nil .ExecData.message)) }}
{{ dbSet .User.ID .ExecData.key $msgId }}
{{ deleteMessage nil $msgId (mult 24 60 60) }}
