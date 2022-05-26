# frozen_string_literal: true
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.max_run_time = 1.day

# configuration to send email to the specified recepients if error occurrs in job
module CustomFailedJob
  def handle_failed_job(job, error)
    super
    # Send email only if the error is raised at the last attempt
    ExceptionNotifier.notify_exception(error) if job.attempts == Delayed::Worker.max_attempts
  end
end

class Delayed::Worker
  prepend CustomFailedJob
end
