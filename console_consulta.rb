require 'consulta_natural'

break_line
pergunta = "Qual o ano do album Nevermind?"
#> banda.nirvana > album.nevermind > ano.x
puts "Pergunta: #{pergunta}"
consulta = ConsultaNatural.interpreta(pergunta)
break_line
puts "Resposta: #{ConsultaNatural.responde(consulta)}"
break_line
puts

while true do
  break_line
  print "Pergunta: "
  pergunta = gets.chomp
  if pergunta=="sair"
    puts "Tchau!\n\n"
    exit
  end
  if consulta = ConsultaNatural.interpreta(pergunta)
    break_line
    print "Resposta: "
    ConsultaNatural.responde(consulta).each{|resp| puts resp}
    break_line
    puts
  end
end

def break_line
  puts "="*50
end