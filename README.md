# Natural Query (Consulta-Natural)

**Semantics** is the study of meaning.  
**Knowledge** can be represented as a graph of information, which in turn is composed of data.  
An **RDF file (Resource Description Framework)** provides a conceptual model of information.  
**Natural language**, as spoken by humans, allows for the creation and navigation of multiple layers of meaning.

**Natural Query (Consulta-Natural)** attempts to map the relationships between the words of a query within a repository, making it possible to infer the intended meaning of the question.

To achieve this, the ontology mapped in the `.RDF` file must serve as a description of facts.  
A **fact** is defined as a subject–predicate–object triple.

Suppose we have a repository of music albums. All subjects are albums:

- *Nevermind* → `is_from_year` → **1991**  
- *In Rainbows* → `is_by_band` → **Radiohead**  
- *Warning* → `has_download_link` → **megaupload.com/xyz**

Now, consider the following question:

```txt
Question = "What is the year of the album Nevermind?"
subject = Nevermind
predicate = year
object = ?
```

Thus, every valid query must provide at least two terms among subject–predicate–object.
The missing element is the query-term, which is then inferred from the facts in the RDF model.

Files
- consulta_natural.rb → Interpreter that generates RDF queries from natural language questions.
- agente_conversa.rb → Enables the interpreter to function as a user within GTalk/Jabber.
- consulta_console.rb → A UNIX-like console for natural language queries.

---
Rafael Polo, 2010
