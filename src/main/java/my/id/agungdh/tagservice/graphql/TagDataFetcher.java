package my.id.agungdh.tagservice.graphql;

import com.netflix.graphql.dgs.*;
import lombok.RequiredArgsConstructor;
import my.id.agungdh.tagservice.entity.Tag;
import my.id.agungdh.tagservice.repository.TagRepository;

import java.util.List;
import java.util.Map;

@DgsComponent
@RequiredArgsConstructor
public class TagDataFetcher {
    private final TagRepository repository;

    @DgsQuery
    public List<Tag> tags() {
        return repository.findAll();
    }

    @DgsQuery
    public Tag tagById(@InputArgument Long id) {
        return repository.findById(id).orElse(null);
    }

    @DgsMutation
    public Tag createTag(@InputArgument String name) {
        return repository.save(new Tag(null, name));
    }

    @DgsMutation
    public Boolean deleteTag(@InputArgument Long id) {
        repository.deleteById(id);
        return true;
    }

    // Federation entity fetcher
    @DgsEntityFetcher(name = "Tag")
    public Tag tag(Map<String, Object> values) {
        return repository.findById(Long.valueOf(values.get("id").toString())).orElse(null);
    }
}