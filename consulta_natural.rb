require 'rubygems'
require 'rdf'
require 'rdf/raptor'
require 'spira'

class Album
  include Spira::Resource
  base_uri 'http://www.baixogavea.com/rdf/album'
  property :banda,             :predicate => RDF::URI.new("http://www.baixogavea.com/rdf/album#banda"), :type => String
  property :ano,                :predicate => RDF::URI.new("http://www.baixogavea.com/rdf/album#ano"), :type => Integer
  property :usuario,         :predicate => RDF::URI.new("http://www.baixogavea.com/rdf/album#usuario"), :type => String
  property :ultimo_link,   :predicate => RDF::URI.new("http://www.baixogavea.com/rdf/album#ultimo_link"), :type => String
  property :criado,           :predicate => RDF::URI.new("http://www.baixogavea.com/rdf/album#criado"), :type => String
end
#a = Album.for(RDF::URI.new("Nevermind"))
#puts a.ano
#puts a.banda

class ConsultaNatural

  @ns = "http://www.baixogavea.com/rdf/album"
  @graph = RDF::Graph.load("repositorio.rdf")

  Spira.add_repository(:default, RDF::Repository.load("repositorio.rdf"))

  def self.pergunta?(frase)
    return frase[-1].chr == "?"
  end

  def self.interpreta(pergunta)
    consulta = {}
    if self.pergunta?(pergunta)
      #break_line
      #puts "Pergunta: #{pergunta}"
      break_line
      pergunta.chop.split(" ").each do |token|
        if semlabel = self.semantic_label(token)
          consulta[semlabel.keys.to_s.intern] = semlabel.values if semlabel
        else
          puts "token: #{token}"
        end
      end
    else
      return false
    end
    return consulta
  end

  def self.responde(consulta)
    return ["Isso não é uma pergunta."] if !consulta

    sujeito = predicado = objeto = nil
    resposta = []

    # qual da tripla falta?
    sujeito = RDF::URI.new(consulta[:subject]) if consulta[:subject]
    predicado = RDF::URI.new(consulta[:predicate]) if consulta[:predicate]
    objeto = consulta[:object] if consulta[:object]

    query_fato = [sujeito, predicado, objeto]
    if query_fato.uniq.count==3
      query = @graph.query(query_fato)
      if query.count>0
        query.each do |fato|
          if sujeito==nil
            resposta << fato.subject
          end
          if predicado==nil          
            resposta << "Sim." if !fato.predicate.to_s.empty?
          end
          if objeto==nil
            resposta << fato.object.to_s
          end
        end
        return resposta
      else
        return ["Não sei."]
      end
    else
      puts query_fato
      return ["Não entendi."]
    end
  end

  # classe, propriedade, valor
  def self.semantic_label(token)
    #sujeito | album
    uri_token = RDF::URI.new(token)
    if @graph.has_subject?(uri_token)
      # quantos = fatos / predicados de sua classe
      quantos =  (@graph.query([uri_token, nil, nil]).count / @graph.predicates.count)
      # os sujeitos do repositório são álbuns
      puts "sujeito: Album = #{token} (#{quantos})"
      return {:subject=>uri_token}
    end

    #predicado
    uri_token = RDF::URI.new(@ns+'#'+token)
    if @graph.has_predicate?(uri_token)
      # sinonimos ?
      puts "predicado: Album.#{token}" if Album.properties.include?(token.intern)
      return {:predicate=>uri_token}
    end

    #objeto
    if @graph.has_object?(token)
      # todos os predicados/atributos com esse token/valor são os mesmos?
      atributos = []
      @graph.query([nil, nil, token]).each do |fato|
        atributos << fato.predicate
      end
      if atributos.uniq.count==1
        attr = atributos[0].to_s.gsub(@ns+"#", "")
        puts "objeto: Album.#{attr} = #{token} (#{ @graph.query([nil, nil, token]).count})"
      end
      return {:object=>token}
    end
  end

end

def break_line
  puts "="*50
end