require "serialport"

class TweLite
  def initialize(port, logfile)
    @port = port
    @logfile = logfile
  end
  def run
    SerialPort.open(@port, 115200, 8, 1, SerialPort::NONE) do |serial|
      File.open(@logfile, "a") do |log|
        Signal.trap(:HUP) do
          log.reopen(@logfile, "a")
        end
        @log = log
        serial.read_timeout = 1000
        serial.gets
        yield serial
        @log = nil
        Signal.trap(:HUP, "DEFAULT")
      end
    end
  end
  def get(line)
    line = line[/[0-9a-fA-F]{48}/]
    data = [line].pack("H*").unpack("C*")
    csum = data.pop
    sum = data.inject(&:+)
    if !csum || !sum || (csum + sum) & 0xff != 0
      puts "data: #{data.inspect}", "line: #{line}", "sum: #{sum}", "checksum: #{csum}"
      raise "checksum error"
    end
    {
      src: data[0] == 0x78 ? :anonymous : data[0],
      data_type: data[1],
      packet: data[2],
      protocol: data[3],
      quolity: data[4],
      client_id: data[5, 4].pack("C*").unpack("N").first,
      dst: data[9] == 0x78 ? :all : data[9],
      clock: data[10] * 256 + data[11],
      relay_flag: data[12] != 0,
      power_mv: data[13] * 256 + data[14],
      reserved: data[15],
      digital: [data[16] & 1 != 0, data[16] & 2 != 0, data[16] & 4 != 0, data[16] & 8 != 0],
      dchange: data[17],
      analog: [data[18], data[19], data[20], data[21]],
      correct: data[22],
    }
  rescue
    return nil
  end
  def put(serial, **data)
    bits = 0
    data.each do |k, v|
      4.times do |i|
        if k == :"d#{i + 1}"
          bit = 2 ** i
          bits |= bit
          bits |= bit *0x100 if v
        end
      end
    end
    serial.write ":788001%04X0000000000000000X\r\n" % bits
  end
  def log(str = nil)
    if str
      @log.puts str
      @log.flush
    else
      @log
    end
  end
end

