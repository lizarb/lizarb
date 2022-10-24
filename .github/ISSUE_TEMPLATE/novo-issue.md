---
name: Novo Issue
about: Novo Issue
title: 'Um titulo que resuma o texto que voce digitou abaixo'
labels: ''
assignees: thiagopintodev

---

### Introducao
Uma linha de texto

### Desenvolvimento
Zero, uma ou mais linhas. Talvez alguns exemplos de codigo, tambem.

```bash
liza new app_1
cd app_1
bundle install
liza test
```

```ruby
class NewCommand < AppCommand
  def self.call args
    log :higher, "Called #{self}.#{__method__} with args #{args}"
    Liza::GenerateCommand.call ["app", *args]
  end
end
```

---

### Conclusao
Garanta que seu texto esta facil de entender
