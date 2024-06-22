package com.example.a1stfirebasedatabase

import android.annotation.SuppressLint
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView

class WelcomeActivity : AppCompatActivity() {
    @SuppressLint("SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_welcome)

        val name = intent.getStringExtra(SignInActivity.KEY1)
        val mail = intent.getStringExtra(SignInActivity.KEY2)
        val number = intent.getStringExtra(SignInActivity.KEY3)
        val id = intent.getStringExtra(SignInActivity.KEY4)

        val welcomeText = findViewById<TextView>(R.id.tVWelcome)
        val mailText = findViewById<TextView>(R.id.tVMail)
        val idText = findViewById<TextView>(R.id.tVUserId)
        val numText = findViewById<TextView>(R.id.tVNumber)

        welcomeText.text = "Welcome $name"
        mailText.text = "Mail: $mail"
        numText.text = "Number: $number"
        idText.text = "User ID: $id"
    }
}