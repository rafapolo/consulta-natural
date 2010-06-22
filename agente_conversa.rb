require 'rubygems'
require 'consulta_natural'
require 'xmpp4r/client'
require 'xmpp4r/roster'
include Jabber

Jabber::debug = true

# conectar
client = Client.new(JID::new("agente@baixogavea.com"))
client.connect
client.auth("*****")
client.send(Presence.new.set_type(:available))
roster = Roster::Helper.new(client)

# aceitar qualquer usuário como amigo
roster.add_subscription_request_callback do |item, pres|
  roster.accept_subscription(pres.from)
  client.send(pres.from, "Olá, bem-vindo à embarcação.")
end

# responder
client.add_message_callback do |m|
  if m.body && consulta = ConsultaNatural.interpreta(m.body)
    resposta = ConsultaNatural.responde(consulta).to_s
    msg = Message::new(m.from, resposta.to_s)
    msg.type=:chat
    client.send(msg)
  end
end

while true
  # continue
end
