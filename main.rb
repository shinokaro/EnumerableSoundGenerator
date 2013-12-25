require "./extend"
require "./vte"
require "./vte_children"
#nil until nil
SAMPLE_RATE = VTE::SAMPLE_RATE
require "pp"
require 'benchmark'
MasterTicks = Ticks.new
sin1 = Sin.new(ticks: MasterTicks, frequency: 440, multiple: 0.5)
gain = Amp.new(ticks: MasterTicks, input: sin1, volume: 3)
sin3 = Sin.new(ticks: MasterTicks, frequency: 0.6)
gain.volume= sin3
wave = nil
puts Benchmark.realtime {
  p wave = MasterTicks.lazy.map(&sin1).take(SAMPLE_RATE)
}
wave.to_sound.play
sleep 1

exit
# sin(para:vol) >> mul(key_seq >> eg(kwargs:vol_objs)) >> amp(vol_obj)

=begin
�����̓n�b�V���A�n�b�V�����U���g�Ƃ�������
�����Ŏ󂯎����OBJ���R�[�����Ă���
�������ɃR�[���œ��ꂷ��K�v
  VTE�̃v���V���Ŏ��ȉ������Ă���
osc >> mul(key_seq >> eg(kwargs:vol_objs)) >> amp(vol_obj)
���ꂪProc�ɂȂ�
a4 v:127, r:0.9, **patarn
b4 v:20
=end
