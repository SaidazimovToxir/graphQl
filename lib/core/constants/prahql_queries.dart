const String fetchProducts = """
query {
  products(limit: 2, offset: 0) {
    id
    title
    price
    description
    category {
      name
    }
  }
}
""";
