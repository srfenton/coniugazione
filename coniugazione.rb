file_path = 'data.tsv'
i_verbi = {}
seen = []

File.open(file_path, 'r') do |file|
  # Skip the header row
  header = file.gets
  file.each_line do |line|
   # Split the line by tab character
    parts = line.split("\t") 

    # Extract verb translation and verb forms from .txt
    infinitivo = parts[0].strip
    traduzione = parts[1].strip
    subject = parts[2].strip.downcase
    presente = parts[3].strip
    passato_prossimo = parts[4].strip
    imperfetto = parts[5].strip
    futuro = parts[6].strip
    condizionale = parts[7].strip
    # these collections need modified to drill down on subject
    
      i_verbi[traduzione] ||= {
      'i' => {},
      'you' => {},
      'he/she' => {},
      'we' => {},
      'you (plural)' => {},
      'they' => {}
    }

    i_verbi[traduzione][subject][:presente] = presente
    i_verbi[traduzione][subject][:passato_prossimo] = passato_prossimo
    i_verbi[traduzione][subject][:imperfetto] = imperfetto
    i_verbi[traduzione][subject][:futuro] = futuro
    i_verbi[traduzione][subject][:condizionale] = condizionale



     end
    # store conjugation data w/ the translation as the key 
end


class Question
 attr_accessor :answer, :translation, :tense, :subject

 def initialize(i_verbi, seen)     

  @i_verbi = i_verbi.dup  # save as instance variable, use dup to avoid modifying outer hash
  
  @answer = i_verbi.keys.sample
  @subject = i_verbi[@answer].keys.sample
  @tense = i_verbi[@answer][@subject].keys.sample 

 end

 def correct?(submitted, answer)

   expected = @i_verbi[answer][@subject][@tense]
    
     if submitted == expected
       puts 'correct'
       

       return true

     else
       puts "\n#{expected} is the answer\n"
     end
 end

end

 # display instructions
system('clear')
puts "press q to quit at any time"
sleep(1)
system('clear')

i = 0
score = 0
while i < i_verbi.size 
  # Begin test
  current_question = Question.new(i_verbi, seen)
  system("clear")
  puts "#{i+1}. #{current_question.answer} \n subject: #{current_question.subject} \n tense: #{current_question.tense} \n "
  seen << current_question.answer
  submitted = nil

  while submitted.nil?
    submitted = $stdin.gets.chomp.strip
    break if submitted.downcase == 'q'  # Check for quit command
  end 
  
  break if submitted.downcase == 'q'  # Exit the main loop if 'q' is entered

  if current_question.correct?(submitted, current_question.answer)
  score += 1
end
  puts "\n"
  puts "score: #{score} / #{i+1}"
  puts "\n"

  sleep(1.25)
  system("clear")
  i += 1 
end

