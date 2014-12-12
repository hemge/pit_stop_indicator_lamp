require 'twelite'

class PitStop < TweLite
  BLINK_CMD = File.dirname(File.dirname(File.dirname(__FILE__))) + "/blink1/commandline/blink1-tool"
  ALERT_SEC = 20
  DEV_NULL = File.exist?("/dev/null") ? "/dev/null" : "NUL"

  def initialize(port, logfile)
    super
    @blink = File.exist?(BLINK_CMD) && "--off"
  end
  def update_alert(now)
    @alert_at = now + ALERT_SEC
    blink if @alert
    @alert_count = nil
  end

  def blink
    return unless @blink
    case
    when @alert_count
      return if @alert_count > 1
      blink = "--red"
    when @light
      blink = "--yellow"
    else
      blink = "--off"
    end
    return if blink == @blink
    @blink = blink
    system(BLINK_CMD, @blink, "-m", "100", out: log)
  end

  def run
    @light = false
    update_alert(Time.now)

    super do |serial|
      loop do
        now = Time.now
        data = get(serial.gets)

        if data[:digital][2]
          log "Sensor"
          @light = data[:analog][0] < 0x7f
          update_alert(now)
        else
          log "LED"
          blink
          if @light != data[:digital][0]
            put(serial, d1: @light)
          end
        end

        alert_offset = Time.now - @alert_at
        if alert_offset > 0
          @alert_count ||= 0
          @alert_count += 1
          @light = (@alert_count / 2) % 2 == 0
        end

        log now.inspect
        log data.inspect
        log ""
      end
    end

    yield @light if block_given?
  ensure
    @alert_count = @light = nil
    blink
  end
end

