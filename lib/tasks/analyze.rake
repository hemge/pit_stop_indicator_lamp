require 'time'
require 'zlib'

desc "show analyze result [dir=\"log/\", w=80, h=20]"
task :analyze do
  w = (ENV["w"] || 80).to_i
  h = (ENV["h"] || 20).to_i
  dir = ENV["dir"] || "log/"

  ary = []
  first = last = nil
  Dir.glob("log/*.log*").sort_by{|file| File.mtime(file)}.each do |file|
    if file =~ /\.gz$/
      buf = Zlib::GzipReader.open(file, &:read)
    else
      buf = File.read(file)
    end
    buf.scan(/Sensor\n(.*)\n.+power_mv=>(\d+)/) do |time, mv|
      first ||= time
      last = time
      ary << mv.to_i
    end
  end

  block = ary.size / w
  lines = Array.new(h) do " " * w end
  min, max = ary.minmax
  w.times do |x|
    lines[(max * h - ary[block * x, block].inject(0) {|s, i| s += i} * h / block) / (max - min)][x] = "*"
  end
  first, last = Time.parse(first), Time.parse(last)
  puts *lines, "mv   : #{min..max} (down: #{max - min})", "first: #{first}", "last : #{last}", "hour : %0.01f" % ((last - first) / 3600.0), "ratio: %0.02f mv/day down" % ((max - min).to_f * 24 * 3600 / (last - first))
end
