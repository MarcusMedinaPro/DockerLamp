
            <?php
            $username = $_POST['username'];
            $password = $_POST['password'];

            if ($username == "admin" && $password == "password") {
                echo "Welcome, " . htmlspecialchars($username) . "!";
            } else {
                echo "Invalid username or password.";
            }
            ?>
        