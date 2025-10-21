{ pkgs, private, bcli, nostril }:

pkgs.writeScript "walletemail" ''
#!${pkgs.bash}/bin/bash

set -e

txid="$1"
wallet="$2"

from="Bitcoin Wallet <bitcoind@monad>"
to="William Casarin <jb55@jb55.com>"
subject="Wallet notification"
keys="-r 0xC5D732336E9DC2C7F9D9D91CAC3CB14001216D67"

tx="$(${bcli} -rpcwallet=$wallet gettransaction "$txid" true)"
address="$(${pkgs.jq}/bin/jq -r '.details[0].address' <<<"$tx")"
details="$(${pkgs.jq}/bin/jq -r '.details[] | [.address, .category, .amount, .label] | @csv' <<<"$tx")"
keypath="$(${bcli} -rpcwallet=$wallet getaddressinfo "$address" | ${pkgs.jq}/bin/jq -r .hdkeypath)"

amount="$(${pkgs.jq}/bin/jq -r '.amount' <<<"$tx")"
confs="$(${pkgs.jq}/bin/jq -r '.confirmations' <<<"$tx")"

time="$(date -d @$(${pkgs.jq}/bin/jq -r '.time' <<<"$tx"))"
received="$(date -d @$(${pkgs.jq}/bin/jq -r '.timereceived' <<<"$tx"))"

export GNUPGHOME=/zbig/bitcoin/gpg

msg="$(printf "txid: %s\n\naddress: %s\n\namount: %s\n\nconfirmations: %d\n\nwallet: %s\n\ntime: %s\n\nreceived: %s\n\nkeypath: %s\n\n%s\n" \
              "$txid" "$address" "$amount" "$confs" "$wallet" "$time" "$received" "$keypath" "$details" )"

${nostril}/bin/nostril --sec ${private.wallet-nostr} --envelope -p 32e1827635450ebb3c5a7d12c1f8e7b2b514439ac10a67eef3d9fd9c5c68e245 --content "$msg" | ${pkgs.nostcat}/bin/nostcat ws://127.0.0.1:8080 wss://notify.damus.io

enctx="$(printf "Content-Type: text/plain\n\n%s\n" "$msg" | ${pkgs.gnupg}/bin/gpg --yes --always-trust --encrypt --armor $keys)"

{
cat <<EOF
From: $from
To: $to
Subject: $subject
MIME-Version: 1.0
Content-Type: multipart/encrypted; boundary="=-=-=";
  protocol="application/pgp-encrypted"

--=-=-=
Content-Type: application/pgp-encrypted

Version: 1

--=-=-=
Content-Type: application/octet-stream

$enctx
--=-=-=--
EOF
} | /run/current-system/sw/bin/sendmail --file /zbig/bitcoin/gpg/.msmtprc -oi -t

printf "sent walletnotify email for %s\n" "$txid"
''
