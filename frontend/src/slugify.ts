import slug from "slugify";

export default function slugify(text: string) {
    return slug(text, { lower: true })
}