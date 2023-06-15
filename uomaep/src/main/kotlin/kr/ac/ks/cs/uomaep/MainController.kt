package kr.ac.ks.cs.uomaep

import com.fasterxml.jackson.core.JsonParser
import jakarta.persistence.Column
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
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.ResponseBody
import java.util.Optional

@Entity
data class MemoEntity(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long?,

    val content: String,

    @Column(nullable = false)
    val certno: Long,
)

@Repository
interface MemoRepo: CrudRepository<MemoEntity, Long>{
    fun findAllByCertno(certno: Long): Iterable<MemoEntity>
}

@Controller
@ResponseBody
class MainController(
    @Autowired val memoRepo: MemoRepo,
) {
    @GetMapping("/memo/{certno}")
    fun index(@PathVariable certno: Long) = memoRepo.findAllByCertno(certno).toList();

    @DeleteMapping("/memo")
    fun deleteMemo(@RequestBody delList: List<Long>): Boolean {
        return Result.runCatching {
            delList.forEach { memoRepo.deleteById(it) }
        }.isSuccess
    }

    @PostMapping("/memo")
    fun addMemo(@RequestBody req: MemoDTO): Boolean {
        return Result.runCatching {
            memoRepo.save(MemoEntity(null, req.content, req.certno))
        }.isSuccess
    }

    @PutMapping("/memo")
    fun updateMemo(@RequestBody req: MemoDTO): Boolean {
        return Result.runCatching {
            memoRepo.save(MemoEntity(req.id, req.content, req.certno))
        }.isSuccess
    }
}

data class MemoDTO(
    val id: Long,
    val content: String,
    val certno: Long,
){}