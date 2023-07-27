. set-creds-queue.ps1

$totalMessages = 10

1..$totalMessages | ForEach-Object -Parallel { 
    $QUEUE_NAME='myqueue'
    az storage message put --content "Enqueued message $_ of $using:totalMessages" --queue-name $QUEUE_NAME
} -ThrottleLimit 10