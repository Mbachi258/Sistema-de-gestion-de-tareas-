package com.mycompany.is.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    public static Connection getConnection() throws SQLException {
        
        String url = "jdbc:mysql://localhost:3308/gestion_tares?useSSL=false&allowPublicKeyRetrieval=true";
String user = "papoi";
String password = "bryan2006";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver no encontrado", e);
        }
    }
}