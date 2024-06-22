package com.example.a1stfirebasedatabase

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import com.google.android.material.textfield.TextInputEditText
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase

class MainActivity : AppCompatActivity() {

    lateinit var database: DatabaseReference
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val button = findViewById<Button>(R.id.btnSignUp)
        val Name = findViewById<TextInputEditText>(R.id.etName)
        val Mail = findViewById<TextInputEditText>(R.id.etMail)
        val Number = findViewById<TextInputEditText>(R.id.etNumber)
        val UserID = findViewById<TextInputEditText>(R.id.etUserID)
        val Password = findViewById<TextInputEditText>(R.id.etPassword)

        button.setOnClickListener {
            val name = Name.text.toString()
            val mail = Mail.text.toString()
            val number = Number.text.toString()
            val userId = UserID.text.toString()
            val password = Password.text.toString()

            val user = User(name, mail, number,  password, userId)
            database = FirebaseDatabase.getInstance().getReference("Users")
            database.child(userId).setValue(user).addOnSuccessListener {
                Name.text?.clear()
                Mail.text?.clear()
                Number.text?.clear()
                UserID.text?.clear()
                Password.text?.clear()
                Toast.makeText(this,"User Registered", Toast.LENGTH_SHORT).show()
            }
        }

        val signInText = findViewById<TextView>(R.id.tVSignIn)
        signInText.setOnClickListener {
            val openSignInActivity = Intent(this, SignInActivity::class.java)
            startActivity(openSignInActivity)
        }
    }
}