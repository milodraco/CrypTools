print "\n"
["C", "r", "y", "p", "T", "o", "o", "l", "s"].each do |l|
  print l
  sleep 0.1
end
sleep 0.25
print " v. 0.98"
sleep 0.5
print "\n                        por Milo Draco\n"
sleep 1

t1 = "\nInstruções gerais: basta rodar o arquivo .rb no terminal
do Linux ou em outro SO e inserir as informações da
transação desejada. Exemplo no Linux: se o arquivo
estiver na pasta pessoal, basta abrir o terminal e
digitar <<ruby CrypTools.rb>>. Lembre de usar ponto
em vez de vírgula nas casas decimais.\n"
t2 = "* Holding: o algoritmo calcula uma nota para uma
criptomoeda de acordo com os dados inseridos, ajudando
o usuário a decidir em qual cripto investir para obter
lucro a longo prazo. Ideal para poupanças (savings e
earn) e stakings).
Instruções: Para calcular o saldo de notícias, você
pode escolher qualquer plataforma para verificar as
notícias (recomendo o app Delta), basta ler as dez
notícias mais recentes dos últimos 3 meses sobre a
cripto e somar +1 para cada notícia boa, -1 para cada
notícia ruim e 0 para notícias neutras ou irrelevantes.\n"
t3 = "* Trading: o algoritmo calcula sinais para fazer
swing trading. Ideal para investidores experientes que
estão acostumados a fazer trading. Pode ser utilizado
em conjunto com análise fundamente e análise gráfica
para aumentar as chances de lucro. Tenha em mente que
o trading envolve alto risco de prejuízo financeiro,
use este algoritmo por própria conta e risco.
Instruções: insira todos os dados corretamente. Ao
analisar o gráfico, você precisará primeiro visualizar
as velas com intervalo de 1 hora. Se constatar que o
mínimo de velas completas negativas foi atingido, passe
a analisar o gráfico com velas em intervalo de 1 minuto.
Ao constatar que o mínimo de velas completas negativas
foi atingido, é sinal de compra. Por exemplo, se o
resultado for 2 velas negativas de horas e 3 velas
nevativas de minutos, o momento de compra será após
uma sequência de 2 velas negativas de intervalos de 1
hora e uma sequência de 3 velas negativas de intervalos
de 1 minuto.
Lembre-se: nenhum método garante o lucro, opere com
trading somente se souber o que está fazendo.\n"

if !File.exist?("cryptools.log") # checando se arquivo de log existe
  print t1 # tutorial
  gets
  print t2
  gets
  print t3
  gets
end
file = File.new("cryptools.log", 'a') # criando arquivo de log
file.write(Time.now, "\n")

print "\n"
loop do
  print "Digite H para HOLDING ou T para TRADING: "
  $opt = gets.chomp.upcase
if $opt == "?" || $opt == "AJUDA"
  print t1 # tutorial
  gets
  print t2
  gets
  print t3
  gets
end
  break if $opt == "H" || $opt == "T"
end

if $opt == "H"
  
# HOLDING
print "\n-=-=-=-=-=-=-=-=-HOLDING-=-=-=-=-=-=-=-=-\n"
loop do
# INPUTS
print "\nInsira o nome da moeda: "
name = gets.chomp.upcase
print "Insira o valor atual da moeda em R$: "
value = gets.chomp.to_f
print "Insira o crescimento em % nos últimos 3 meses: "
c3 = gets.chomp
if c3 == ""
  print "ERRO: CRESCIMENTO DO ÚLTIMO TRIMESTRE NÃO INSERIDO!\n"
  exit
  else
  c3 = c3.to_f
end
print "Insira o crescimento em % nos últimos 6 meses: "
c6 = gets.chomp
print "Insira o crescimento em % nos últimos 12 meses: "
c12 = gets.chomp
if c6 == "" || c12 == ""
  nohist = true # sem histórico
  else
  nohist = false
end
c6 = c6.to_f
c12 = c12.to_f
print "Insira o saldo das dez últimas notícias (boas - ruins)
dentro dos últimos 3 meses: "
news = gets.chomp
if news == ""
  nonews = true # sem saldo de notícias
  news = 5
  else
  nonews = false
  news = news.to_i
  news = 10 if news > 10
end

# CÁLCULOS
svalue = Math.log(500000) - Math.log(value) # avaliação do valor unitário da moeda
if svalue > 10
  svalue = 10 + Math.sqrt(svalue-10)
  elsif svalue < 0
  svalue *= 2
end
if nohist == true
  volat = 10.0 # volatilidade caso não haja histórico
  else
  volat = (((c3 * 2) - c6).abs + ((c6 * 2) - c12).abs)**0.25 # avaliação da volatilidade
end
fator = 5.5 + volat # fator divisor de acordo com a volatilidade para avaliação do crescimento
if fator < 7
  fator = 7.0
  elsif fator > 21
  fator = 21.0
end
if nohist == false
  cresc = ((c3 + c6 + c12)/fator).abs**(1/3.0) * 2 # avaliação do crescimento
  else
  cresc = c3.abs**(1/3.0) * 2
end
cresc *= -1 if c3+c6+c12 < 0 # valores negativos
if nohist == false
  if c3 < c6/2.0 && c6 < c12/2.0
    dip = true # mergulho
    else
    dip = false
  end
  if c3 > c6/2.0 && c3 > c12/4.0
    climb = true # alto crescimento no último trimestre
    else
    climb = false
  end
  else
  dip = false
  climb = false
end
score = cresc + svalue + news - volat # avaliação final
if dip == true
  score -= ((c3 - (c6/2.0)) + (c6 - (c12/2.0))).abs**0.25 # penalidade em caso de mergulho
  elsif climb == true
  score += ((c3 - (c6/2.0)) + (c6 - (c12/2.0))).abs**(1/3.0) # bônus em caso de alto crescimento
end
score = score.round(2)

# RESULTADO
print "\nValor: #{svalue.round(2)}"
if svalue > 10
  print " (excelente!)\n"
  elsif svalue > 7
  print " (bom)\n"
  elsif svalue > 4
  print " (razoável)\n"
  elsif svalue > 0
  print " (oneroso)\n"
  else
  print " (muito oneroso!)\n"
end
print "Crescimento: #{cresc.round(2)}"
if cresc > 15
  print " (excelente!)\n"
  elsif cresc > 10
  print " (bom)\n"
  elsif cresc > 5
  print " (razoável)\n"
  elsif cresc > 0
  print " (baixo)\n"
  elsif cresc == 0
  print " (nulo)\n"
  else
  print " (negativo!)\n"
end
if nohist == false
  print "Volatilidade: #{volat.round(2)}"
  if volat > 10
    print " (muito alta!)\n"
    elsif volat > 7
    print " (alta)\n"
    elsif volat > 4
    print " (razoável)\n"
    elsif volat > 0
    print " (estável)\n"
    else
    print " (nula!)\n"
  end
end
if nonews == false
  print "Notícias: #{news.round}"
  if news >= 10
    print " (promissoras!)\n"
    elsif news >= 7
    print " (boas)\n"
    elsif news >= 4
    print " (razoáveis)\n"
    elsif news >= 0
    print " (ruins)\n"
    else
    print " (péssimas!)\n"
  end
end
warn = [] # alertas
warn << "em declínio!" if dip == true
warn << "tendência de alta!" if climb == true
warn << "histórico incompleto" if nohist == true
warn << "notícias desconhecidas" if nonews == true
if warn.length > 0
  print "Alertas:"
  warn.each do |a|
    print " ", a
    print "," if a != warn[-1]
  end
  print "\n"
end
print "Score final: #{score}"
if score >= 30
  print result = " (investimento altamente recomendável!)"
  elsif score >= 20
  print result = " (investimento recomendável)"
  elsif score >= 10
  print result = " (razoável)"
  elsif score >= 5
  print result = " (duvidoso)"
  else
  print result = " (não recomendado!)"
end
print "\n"
file.write("#{name} (R$ #{value}): #{score}#{result}", "\n") # escrevendo log
print "\nCalcular outra criptomoeda? (s/n) "
lp = gets.chomp.upcase
if lp == "N"
  file.write("\n") 
  exit
end
end

elsif $opt == "T"

# TRADING
print "\n-=-=-=-=-=-=-=-=-TRADING-=-=-=-=-=-=-=-=-

ATENÇÃO! SAIBA QUE O TRADING ENVOLVE ALTO RISCO DE
PREJUÍZO, NÃO NEGOCIE A NÃO SER QUE VOCÊ TENHA CERTEZA
QUE SABE O QUE ESTÁ FAZENDO. NENHUM MÉTODO PODE GARANTIR
O LUCRO.\n"

loop do
# INPUTS
print "\nInsira o par que será negociado (ex: BTC/USDT): "
par = gets.chomp.upcase
print "Insira a quantia que será investida (em BRL ou USD): "
banca = gets.chomp.to_f
print "Insira o crescimento da criptomoeda no último mês (30
dias): "
c1 = gets.chomp.to_f
print "Insira o crescimento da criptomoeda no último trimestre: "
c3 = gets.chomp.to_f
print "Insira o crescimento da criptomoeda no último semestre: "
c6 = gets.chomp.to_f
if (c3*2)+(c6/2.0) < 0 || (c1*6)+(c3*2) < 0
  print "ERRO: RENDIMENTO NEGATIVO!\n"
  exit
end
print "Insira o perfil (moderado: 1, agressivo: 2, ultra
agressivo: 3): "
perfil = gets.chomp.to_i
if perfil != 1 && perfil != 2 && perfil != 3
  print "ERRO: PERFIL INVÁLIDO!\n"
  exit
end

# CÁLCULOS
seqh = 10 - (Math.sqrt((c3 * 2) + (c6 / 2.0)) / 10.0) # sequência de velas de horas
seqh = 2 + ((seqh - 2)/2.0) if perfil >= 2 && seqh > 2
seqh = seqh.round
seqh = 0 if seqh < 0
seqm = 10 - (Math.sqrt((c1 * 6) + (c3 * 2.0)) / 10.0) # sequência de velas de minutos
seqm = 3 + ((seqm - 3)/2.0) if perfil == 3 && seqm > 3
seqm = seqm.round
seqm = 1 if seqm < 1
stop = banca * (1 + (Math::log(c3 + (c1 * 3.0)) / 100.0)) # sinal de venda
stop *= 1 + (((perfil - 1) * 2.5) / 100.0)
stop = stop.round
lucro = (((stop / banca.to_f) - 1) * 100).round(2) # porcentagem de lucro
volat = ((c1 - (c3 / 3.0)).abs + (c3 - (c6 / 2.0)).abs + (c1 - (c6 / 6.0)).abs) / 3.0 # volatilidade
if c1 > 0
  x1 = Math.sqrt(c1)
  else
  x1 = c1 / 3.0
end
if c3 > 0
  x3 = Math.sqrt(c3 / 3.0)
  else
  x3 = c3
end
if c6 > 0
  x6 = Math::log(c6) * 2
  else
  x6 = c6
end
chance = x1 + x3 + x6 + ((3 - perfil) * 5) - (Math.sqrt(volat) - 20) # probabilidade de lucro
if chance > 50
  chance = 50 + Math.sqrt(chance - 50)
  elsif chance < 5
  chance = 5 - Math::log(volat)
end
if chance > 70
  chance = 70.0
  elsif chance < 1
  chance = 1.0
end

# RESULTADO
print "\nProbabilidade de lucro: #{chance.round(2)}%
Volatilidade: #{volat.round(2)}%"
if chance < 20 || volat > 100 # alertas
  print "\nAlertas: "
  if chance < 20 && volat > 100
    print "alta volatilidade!, baixa probabilidade de lucro!"
    elsif chance < 20
    print "baixa probabilidade de lucro!"
    elsif volat > 100
    print "alta volatilidade!"
  end
end
print "\nSinais:
* Comprar após #{seqh} velas negativas de horas e #{seqm} velas
negativas de minutos;
* Vender quando a quantia atingir o valor de $ #{stop}.00
(+#{lucro}%).\n"
file.write("$ #{banca} em #{par}: #{seqh} horas e #{seqm} min negativos, vender em $ #{stop} (+#{lucro}%)", "\n") # escrevendo log
print "\nCalcular outra negociação? (s/n) "
lp = gets.chomp.upcase
if lp == "N"
  file.write("\n")
  exit
end
end
end