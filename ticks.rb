=begin
==Ticks�ɂ���
�@Ticks�͐����ł��B0����n�܂�1���������܂��B
�@Ticks�͔�т̂��鑝���͂���܂���B�܂�A2�ȏ�̑����͂��肦�܂���B
�@Ticks�͓����Ń}�C�i�X�l���Ƃ邱�Ƃ�����܂����A���̏ꍇ�͒l���}�C�i�X�̊ԁA���0���o�͂��܂��B
�@Ticks�Ɉˑ����鏈���͂��A�̂��Ƃ�O��Ƃ��Ă��܂��܂���B
=end
class Ticks < Enumerator  
  def initialize(ticks=0)
    super { |output| ticks += 1 while output << (0 < ticks ? ticks : 0) }
  end
  alias tick! next
  alias ticks peek
end
