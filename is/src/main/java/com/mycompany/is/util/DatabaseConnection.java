package com.mycompany.is.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    public static Connection getConnection() throws SQLException {
        
        String url = "jdbc:mysql://localhost:3308/gestion_tareas?useSSL=false&allowPublicKeyRetrieval=true";
String user = "root";
String password = ""; // o tu contraseña si la tienes
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver no encontrado", e);
        }
    }
}