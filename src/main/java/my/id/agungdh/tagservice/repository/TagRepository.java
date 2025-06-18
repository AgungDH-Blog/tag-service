package my.id.agungdh.tagservice.repository;

import my.id.agungdh.tagservice.entity.Tag;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TagRepository extends JpaRepository<Tag, Long> {
}