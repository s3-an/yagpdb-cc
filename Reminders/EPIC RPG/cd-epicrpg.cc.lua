 {{ $cSendId := 40 }}
 
 {{ $donatorCdMultiplier := 1.0 }}
 {{ $marriedCdMultiplier := 1.0 }}
 {{ $globalCd := 1.0 }}
 
 {{/* DONATOR ROLE */}}
 {{ if (hasRoleID 754566707603046480) }}
     {{ $donatorCdMultiplier = 0.9 }}
 {{ else if (hasRoleID 754566715467104256) }}
     {{ $donatorCdMultiplier = 0.8 }}
 {{ else if (hasRoleID 754566746991493240) }}    
     {{ $donatorCdMultiplier = 0.65 }}
 {{ end }}
 
 {{/* MARRIED ROLE */}}
 {{ if (hasRoleID 754567031235412028) }}
     {{ $marriedCdMultiplier = 0.9 }}
 {{ else if (hasRoleID 754567033915572275) }}
     {{ $marriedCdMultiplier = 0.8 }}
 {{ else if (hasRoleID 754567036948054079) }}
     {{ $marriedCdMultiplier = 0.65 }}
 {{ end }}
 
 {{/* GLOBAL COOLDOWN CD */}}
 {{ $globalCdObj := (dbGet 555955826880413696 "globalCd") }}
 {{ if $globalCdObj }}
     {{ $globalCd = $globalCdObj.Value }}
 {{ end }}
 
 {{ if (le $donatorCdMultiplier $marriedCdMultiplier) }}
     {{ $marriedCdMultiplier = $donatorCdMultiplier }}
 {{ end }}
 
 {{/* COOLDOWN VARS */}}
 {{ $cdHunt := (roundCeil (mult $globalCd $donatorCdMultiplier 60)) }}
 {{ $cdHuntTogether := (roundCeil (mult $globalCd $marriedCdMultiplier 60)) }}
 {{ $cdWork := (roundCeil (mult $globalCd $donatorCdMultiplier 5 60)) }}
 {{ $cdTraining := (roundCeil (mult $globalCd $donatorCdMultiplier 15 60)) }}
 {{ $cdAdventure := (roundCeil (mult $globalCd $donatorCdMultiplier 60 60)) }}
 {{ $cdHorse := (roundCeil (mult $globalCd $donatorCdMultiplier 24 60 60)) }}
 {{ $cdArena := (roundCeil (mult $globalCd $donatorCdMultiplier 24 60 60)) }}
 {{ $cdMiniboss := (roundCeil (mult $globalCd $donatorCdMultiplier 12 60 60)) }}
 {{ $cdQuest := (roundCeil (mult $globalCd $donatorCdMultiplier 6 60 60)) }}
 {{ $cdPets := (roundCeil (mult $globalCd 4 60 60)) }}
 {{ $cdLootbox := (roundCeil (mult $globalCd 3 60 60)) }}
 {{ $cdDaily := (mult 24 60 60) }}
 {{ $cdWeekly := (mult 7 24 60 60) }}
 {{ $cdVote := (mult 12 60 60) }}
 {{ $cdGuild := (mult 2 60 60) }}
 {{ $cdDuel := (mult 2 60 60) }}
 {{/* Variables */}}
 {{ $args := (lower (joinStr " " .CmdArgs)) }}
 {{ $command := (lower (index .CmdArgs 0)) }}
 {{ $notifMsg := false }}
 {{ $dbKey := false }}
 {{ $cmdCd := false }}
 {{ $isAsc := false }}
 
 {{ if ( (eq $command "ascended") and (gt (len .CmdArgs) 1) ) }}
     {{ $args = (reReplace `^ascended\s+` $args "") }}
     {{ $isAsc = true }}
     {{ $command = (lower (index .CmdArgs 1)) }}
 {{ end }}
 
 {{/* HUNT */}}
 {{ if (eq $command "hunt") }}
     {{ $dbKey = (printf "%s.%s" .User.ID "hunt") }}
         {{ $notifMsg = (printf "**HUNT** %s" .User.Mention)}}
         {{ $cmdCd = $cdHunt }}
     {{ if (reFind `^hunt t(ogether)?\s*` $args) }}
         {{ $notifMsg = (printf "**%s** %s" (upper $args) .User.Mention) }}
         {{ $cmdCd = $cdHuntTogether }}
     {{ else if (reFind `^hunt h(ardmode|t)?\s*` $args) }}
     {{ end }}
 
 {{/* WORK */}}
 {{ else if (reFind `^(chop|axe|bowsaw|chainsaw|pickup|ladder|tractor|greenhouse|fish|net|boat|bigboat|mine|drill|pickaxe|dynamite)\s*` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "work") }}
     {{ $cmdCd = $cdWork }}
     {{ $notifMsg = (printf "**%s** %s" (upper $command) .User.Mention) }} 
 {{/* TRAINING */}}
 {{ else if (reFind `^(training|tr)\s*` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "training") }}
     {{ $cmdCd = $cdTraining }}
     {{ $notifMsg = (printf "**TRAINING** %s" .User.Mention) }}
 {{ else if (reFind `^(ultraining|ultr)\s*` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "training") }}
     {{ $cmdCd = $cdTraining }}
     {{ $notifMsg = (printf "**ULTRAINING** %s" .User.Mention) }}
 
 
 {{/* ADVENTURE */}}
 {{ else if (reFind `^(adventure|adv)\s*` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "adv") }}
     {{ $cmdCd = $cdAdventure }}
     {{ $notifMsg = (printf "**ADVENTURE** is ready %s" .User.Mention)}}
 
 
 {{/* MINIBOSS */}}
 {{ else if (reFind `^(miniboss|dungeon)\s*` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "miniboss") }}
     {{ $cmdCd = $cdMiniboss }}
     {{ $notifMsg = (printf "**%s** %s" (upper $command) .User.Mention) }}
 {{ else if (reFind `^not\s+so\s+mini\s+boss\s+join` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "miniboss") }}
     {{ $cmdCd = $cdMiniboss }}
     {{ $notifMsg = (printf "**NOT SO MINI BOSS** %s" .User.Mention) }}
 
 {{/* QUEST/EPIC QUEST */}}
 {{ else if (reFind `^(epic\s+quest|quest)\s*` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "quest") }}
     {{ $cmdCd = $cdQuest }}
     {{ $notifMsg = (printf "**QUEST** is ready. :notes: %s" .User.Mention) }}
     
 {{/* DUEL */}}
 {{ else if (eq $command "duel") }}
     {{ $dbKey = (printf "%s.%s" .User.ID "duel") }}
     {{ $cmdCd = $cdDuel }}
     {{ $notifMsg = (printf "**DUEL** %s" .User.Mention) }}
 
 {{/* ARENA */}}
 {{ else if (eq $command "arena") }}
     {{ $dbKey = (printf "%s.%s" .User.ID "arena") }}
     {{ $cmdCd = $cdArena }}
     {{ $notifMsg = (printf "**ARENA** %s" .User.Mention) }}
 {{ else if (reFind `^big\sarena\sjoin` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "arena") }}
     {{ $cmdCd = $cdArena }}
     {{ $notifMsg = (printf "**BIG ARENA** %s" .User.Mention) }}
 
 {{/* VOTE */}}
 {{ else if (eq $command "vote") }}
     {{ $dbKey = (printf "%s.%s" .User.ID "vote") }}
     {{ $cmdCd = $cdVote }}
     {{ $notifMsg = (printf "**VOTE** %s" .User.Mention) }}
 
 {{/* DAILY */}}
 {{ else if (eq $command "daily") }}
     {{ $dbKey = (printf "%s.%s" .User.ID "daily") }}
 {{ $cmdCd = $cdDaily }}
     {{ $notifMsg = (printf "**DAILY** %s" .User.Mention) }}
 
 {{/* WEEKLY */}}
 {{ else if (eq $command "weekly") }}
     {{ $dbKey = (printf "%s.%s" .User.ID "weekly") }}
     {{ $cmdCd = $cdWeekly }}
     {{ $notifMsg = (printf "**WEEKLY** %s" .User.Mention) }}
 
 {{/* HORSE BREED/RACE */}}
 {{ else if (reFind `^horse\s+(breeding|breed|race)\s*` $args) }}
     {{ $subCmd := (lower (index .Args 2)) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "horse") }}
     {{ $cmdCd = $cdHorse }}
     {{ $notifMsg = (printf "**HORSE %s** %s" (upper $subCmd) .User.Mention) }}
 
 {{/* BUY LOOTBOX */}}
 {{ else if (reFind `^buy\s+((c|u|r|ep|ed)\s+lb|(common|uncommon|rare|epic|edgy)\s+lootbox)\s*` $args) }}
     {{ $dbKey = (printf "%s.%s" .User.ID "lootbox") }}
     {{ $cmdCd = $cdLootbox }}
     {{ $notifMsg = (printf "**BUY LOOTBOX** %s" .User.Mention) }}

 {{/* PET ADVENTURE */}}
 {{ else if (and (or (eq $command "pet") (eq $command "pets")) (gt (len .Args) 4)) }}
     {{ $petId := (upper (index .Args 3)) }}
     {{ $petTask := (upper (index .Args 4)) }}
     {{ if (or (eq (lower (index .Args 2)) "adv") (eq (lower (index .Args 2)) "adventure")) }}
         {{ $dbKey = (printf "%s.%s.%s" .User.ID "pets" $petId) }}
         {{ $cmdCd = $cdPets }}
         {{ $notifMsg = (printf "**PET ADVENTURE %s %s** %s" (upper $petId) (upper $petTask) .User.Mention) }}
     {{ end }}
 
 
 {{/* GUILD UPGRADE/RACE */}}
 {{ else if (and (eq $command "guild") (gt (len .Args) 2)) }}
     {{ $gCommand := (lower (index .Args 2)) }}
     {{ if (or (eq $gCommand "raid") (eq $gCommand "upgrade")) }}
         {{ $dbKey = (printf "%s.%s" .User.ID "guild") }}
         {{ $cmdCd = $cdGuild }}
         {{ $notifMsg = (printf "**GUILD %s** %s" (upper $gCommand) .User.Mention) }}
     {{ end }}
 {{ end }}
{{ end }}
 
 
 {{ if (and $notifMsg $dbKey $cmdCd) }}
  {{/* sendMessage nil (upper (toString (toDuration (printf "%ds" (toInt (roundCeil $cmdCd)))))) */}}  {{/* For testing only */}}
 
     {{ if ($isAsc) }}
         {{ $notifMsg = (printf "**ASCENDED** %s" $notifMsg) }}
     {{ end }}
     {{ $notifMsg = (printf "RPG %s" $notifMsg) }}
     {{ $dbMsgId := (dbGet .User.ID $dbKey) }}
     {{ deleteMessage nil (toString $dbMsgId.Value) 1 }}
     {{ $s := (scheduleUniqueCC $cSendId nil $cmdCd $dbKey (sdict "message" $notifMsg "delay" $cmdCd "key" $dbKey)) }}
 {{ end }}
