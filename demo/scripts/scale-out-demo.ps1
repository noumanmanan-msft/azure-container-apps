$totalMessages = 30

1..$totalMessages | ForEach-Object -Parallel { 
    $queueName = "containerapps-queue"
    az storage message put --content "Enqueued message $($_) of $using:totalMessages" -q $queueName     
} -ThrottleLimit 10
