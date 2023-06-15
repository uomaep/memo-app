package kr.ac.ks.cs.uomaep

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Controller
import org.springframework.stereotype.Repository
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.ResponseBody
import java.security.MessageDigest
import java.util.Optional

@Entity
data class UserEntity(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val userNo: Long?,

    @Column(unique = true, nullable = false)
    val id: String,

    @Column(nullable = false)
    val password: String,
)

@Repository
interface UserRepo: CrudRepository<UserEntity, Long> {
    fun findById(id: String): Optional<UserEntity>
    fun findByIdAndPassword(id: String, password: String): Optional<UserEntity>
}

@Controller
@ResponseBody
class UserController(@Autowired val userRepo: UserRepo) {
    @PostMapping("/login")
    fun login(@RequestBody req: UserDTO): Long {
        val user = userRepo.findByIdAndPassword(id = req.id, password = toSHA512(req.password))
        if(!user.isPresent) return -1
        return user.get().userNo ?: -1
    }

    @PostMapping("/register")
    fun register(@RequestBody req: UserDTO): Boolean {
        val user = userRepo.findById(req.id)
        if(user.isPresent) return false

        return Result.runCatching {
            userRepo.save(UserEntity(null, req.id, toSHA512(req.password)))
        }.isSuccess
    }

    fun toSHA512(str: String): String {
        val bytes = MessageDigest.getInstance("SHA-512").digest(str.toByteArray())
        val hexString = StringBuilder(128)
        for(i in bytes.indices) {
            val hex = Integer.toHexString(0xFF and bytes[i].toInt())
            if(hex.length == 1) hexString.append('0')
            hexString.append(hex)
        }
        return hexString.toString()
    }
}

data class UserDTO(
    val id: String,
    val password: String,
)