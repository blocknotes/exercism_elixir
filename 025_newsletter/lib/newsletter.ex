defmodule Newsletter do
  def read_emails(path) do
    {:ok, content} = File.read(path)
    content = String.trim(content)
    if content != "", do: String.split(content, "\n"), else: []
  end

  def open_log(path), do: File.open!(path, [:write])

  def log_sent_email(pid, email), do: IO.puts(pid, email)

  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun) do
    pid = open_log(log_path)

    for email <- read_emails(emails_path) do
      case send_fun.(email) do
        :ok -> log_sent_email(pid, email)
        _ -> false
      end
    end

    close_log(pid)
  end
end
