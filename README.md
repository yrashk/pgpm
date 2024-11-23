# Postgres.pm

**Postgres.pm** (aka **pgpm**) is a streamlined package manager designed to simplify the process of building and
distributing Postgres extensions and packages.

## Key objectives

<details>
<summary>Platform independence</summary>

Postgres.pm is designed to deliver Postgres extensions
in native packaging (such as RPM, DEB, OCI images, etc.)
to support the broad variety of usage patterns.

> [!NOTE]
> Early release is targeting RHEL-based distributions using
> official PGDG Postgres distributions with other options
> coming up.
</details>

<details>
<summary>Low-effort package maintenance</summary>

Postgres.pm embraces the concept of inferences: based
on given information, it'll figure out how to build the package
if it fits into a set of pre-defined rules.

New versions are automatically picked up and recognized.

Package definition can be as simple as this – with no routine
maintenace on new releases:

```ruby

class Pgvector < Pgpm::Package
  github "pgvector/pgvector"
end
```

</details>

<details>
<summary>Package definition flexibility</summary>

Packages definitions are defined in Ruby, allowing for near-infinite
flexibility of their definition when necessary.

This allows us to accomodate non-standard build and installation procedures
with ease.
</details>

---

### Current Status

We are preparing to start publishing RPM packages publicly soon. It's possible to build included packages manually.