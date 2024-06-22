package com.example.a1stfirebasedatabase

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import com.google.android.material.textfield.TextInputEditText
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase

class SignInActivity : AppCompatActivity() {

    private lateinit var databaseReference: DatabaseReference

    companion object{
        const val KEY1 = "com.example.a1stfirebasedatabase.SignInActivity.name"
        const val KEY2 = "com.example.a1stfirebasedatabase.SignInActivity.mail"
        const val KEY3 = "com.example.a1stfirebasedatabase.SignInActivity.number"
        const val KEY4 = "com.example.a1stfirebasedatabase.SignInActivity.id"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_in)

        val signInButton = findViewById<Button>(R.id.btnSignIn)
        val userName = findViewById<TextInputEditText>(R.id.etUserID)

        signInButton.setOnClickListener {
            val userId = userName.text.toString()
            if (userId.isNotEmpty()){
                readData(userId)
            }else{
                Toast.makeText(this, "Please enter user id", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun readData(userId: String) {
        databaseReference = FirebaseDatabase.getInstance().getReference("Users")
        databaseReference.child(userId).get().addOnSuccessListener {
            //if user exist or nor
            if(it.exists()){

                //Welcome user in your app with intent and also pass
                val name = it.child("name").value
                val email = it.child("email").value
                val number = it.child("number").value
                val id = it.child("id").value

                val intentWelcome = Intent(this, WelcomeActivity::class.java)
                intentWelcome.putExtra(KEY1, name.toString())
                intentWelcome.putExtra(KEY2, email.toString())
                intentWelcome.putExtra(KEY3, number.toString())
                intentWelcome.putExtra(KEY4, id.toString())
                startActivity(intentWelcome)

            }else{
                Toast.makeText(this, "User doesn't exist. Please sign up at first", Toast.LENGTH_SHORT).show()
            }
        }.addOnFailureListener{
            Toast.makeText(this, "Failed! Error in DB", Toast.LENGTH_SHORT).show()
        }
    }
}