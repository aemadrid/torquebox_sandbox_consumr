class UpcaseService
  def initialize(options={})
    puts "<<< UpcaseService >>> :: initialize : starting ..."
    @halt = false
    puts "<<< UpcaseService >>> :: initialize : done ..."
  end

  def start
    puts "<<< UpcaseService >>> :: start : starting thread..."
    @queue_thread = Thread.new { start_queue }
    puts "<<< UpcaseService >>> :: start : done ...."
  end

  def stop
    puts "<<< UpcaseService >>> :: stop : stopping..."
    # Notify our queue receiver to stop
    @halt = true
    # Wait for all spawned threads to exit
    @queue_thread.join
    puts "<<< UpcaseService >>> :: stop : done ..."
  end

  protected

  def start_queue
    puts "<<< UpcaseService >>> :: start_queue : starting ..."
    queue = TorqueBox::Messaging::Queue.new('/queues/upcase')

    while true do
      queue.receive_and_publish(:timeout => 500) do |message|
        result = message.to_s.upcase
        puts "<<< UpcaseService >>> :: Received term [#{message}] and returning [#{result}]"
        result
      end

      # Jump out of the loop if we're shutting down
      if @halt
        puts puts "<<< UpcaseService >>> :: start_queue : stopping ..."
        break
      end
    end

    puts "<<< UpcaseService >>> :: start_queue : finished ..."
  end

end
