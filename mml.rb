class MML
  octave      = (0..8).to_a
  key_and_num = ("a".."g").to_a.rotate(2).zip([0, 2, 4, 5, 7, 9, 11])
  option      = ["b", "", "s"].zip([-1, 0, 1])
  name_and_note = octave.map { |oct|
    key_and_num.map { |key, num|
      option.map { |opt, offset|
        [[key, oct, opt].join.to_sym, oct * 12 + num + offset + 12]
      }
    }
  }.flatten!
  
  @@note_map = Hash[*name_and_note]
  
  class << self
    def name_to_note(name)
      @@note_map[name]
    end
    def note_to_freq(note)
      440 * 2 ** Rational((note - 69), 12)
    end
    def name_to_freq(name)
      note_to_freq(name_to_note(name))
    end
  end
  
  
  def initialize
  end
  def method_missing(name, *args, **kwargs)
    MML.name_to_freq(name)
  end
  # c4 + e4 + g4 kw:55
end
p MML.new.a3
