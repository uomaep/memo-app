package kr.ac.ks.cs.uomaep

import com.fasterxml.jackson.core.JsonParser
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Controller
import org.springframework.stereotype.Repository
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.ResponseBody

@Entity
data class MemoEntity(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long?,

    val content: String,
)

@Repository
interface MemoRepo: CrudRepository<MemoEntity, Long>{}

@Controller
@ResponseBody
class MainController(
    @Autowired val memoRepo: MemoRepo,
) {
    @GetMapping("/memo")
    fun index() = memoRepo.findAll().toList();

    @DeleteMapping("/memo")
    fun deleteMemo(@RequestBody delList: List<Long>): Boolean {
        return Result.runCatching {
            delList.forEach { memoRepo.deleteById(it) }
        }.isSuccess
    }

    @PostMapping("/memo")
    fun addMemo(@RequestBody req: MemoDTO): Boolean {
        return Result.runCatching {
            memoRepo.save(MemoEntity(null, req.content))
        }.isSuccess
    }

    @PutMapping("/memo")
    fun updateMemo(@RequestBody req: MemoDTO): Boolean {
        return Result.runCatching {
            memoRepo.save(MemoEntity(req.id, req.content))
        }.isSuccess
    }
}

data class MemoDTO(
    val id: Long,
    val content: String,
){}