<?php
if (!function_exists('mysql_connect')) {
    function mysql_connect($host, $user, $pass, $new_link = false) {
        global $mysql_last_link;
        $mysqli = new mysqli($host, $user, $pass);
        if ($mysqli->connect_error) {
            return false;
        }
        $mysql_last_link = $mysqli;
        return $mysqli;
    }

    function mysql_select_db($dbname, $link = null) {
        global $mysql_last_link;
        $conn = $link ?: $mysql_last_link;
        return $conn->select_db($dbname);
    }

    function mysql_query($sql, $link = null) {
        global $mysql_last_link;
        $conn = $link ?: $mysql_last_link;
        return $conn->query($sql);
    }

    function mysql_fetch_array($result, $type = MYSQLI_BOTH) {
        return $result->fetch_array($type);
    }

    function mysql_fetch_assoc($result) {
        return $result->fetch_assoc();
    }

    function mysql_close($link = null) {
        global $mysql_last_link;
        $conn = $link ?: $mysql_last_link;
        return $conn->close();
    }

    function mysql_error($link = null) {
        global $mysql_last_link;
        $conn = $link ?: $mysql_last_link;
        return $conn->error;
    }

    function mysql_num_rows($result) {
        return $result->num_rows;
    }

    function mysql_affected_rows($link = null) {
        global $mysql_last_link;
        $conn = $link ?: $mysql_last_link;
        return $conn->affected_rows;
    }

    function mysql_insert_id($link = null) {
        global $mysql_last_link;
        $conn = $link ?: $mysql_last_link;
        return $conn->insert_id;
    }

    function mysql_real_escape_string($string, $link = null) {
        global $mysql_last_link;
        $conn = $link ?: $mysql_last_link;
        return $conn->real_escape_string($string);
    }

    function mysql_free_result($result) {
        return $result->free();
    }
}
