// Colorscheme palette sampler — every common TS token kind in one file.
/** JSDoc block: {@link Repo} keeps generics + docs highlighting visible. */

import { readFile } from "node:fs/promises";

export const MAX_RETRIES = 3;
const TAG = `retry:${MAX_RETRIES}`;

export enum Level {
  Debug = 0,
  Warn = 1,
  Error = 2,
}

export type Id = string | number;

// Numeric literal forms.
const HEX = 0xff;
const BIN = 0b1010;
const OCT = 0o755;
const BIG = 9_007_199_254_740_993n;
const FLOAT = 1.5e-3;

const SYM: unique symbol = Symbol("marker");

// Type-level constructs.
type Keys = keyof User;
type Getter<T> = T extends { id: infer I } ? I : never;
type Route = `/${string}/edit`;
type Mutable<T> = { -readonly [K in keyof T]-?: T[K] };
type Falsy = null | undefined | 0 | "";

export interface User {
  readonly id: Id;
  name: string;
  level?: Level;
  meta: Record<string, unknown>;
}

type Partialize<T> = { [K in keyof T]?: T[K] };

export abstract class Repo<T extends { id: Id }> {
  protected items = new Map<Id, T>();
  static instances = 0;
  #secret = "private field";
  declare readonly brand?: string;

  constructor(private readonly label: string) {
    Repo.instances++;
  }

  abstract validate(item: Partialize<T>): boolean;

  get size(): number {
    return this.items.size;
  }

  set tag(value: string) {
    this.#secret = value;
  }

  add(item: T): this {
    if (!this.validate(item)) throw new Error(`${this.label}: invalid item`);
    this.items.set(item.id, item);
    return this;
  }

  *[Symbol.iterator](): Generator<T> {
    for (const item of this.items.values()) yield item;
  }
}

class UserRepo extends Repo<User> {
  validate(item: Partialize<User>): boolean {
    return typeof item.name === "string" && item.name.length > 0;
  }
}

// Overload signatures.
export function pick(source: User): string;
export function pick(source: User[], index: number): string;
export function pick(source: User | User[], index = 0): string {
  return Array.isArray(source) ? source[index]!.name : source.name;
}

export async function load(path: string): Promise<User[]> {
  outer: for (let i = 0; i < MAX_RETRIES; i++) {
    try {
      const raw = await readFile(path, "utf8");
      return JSON.parse(raw) as User[];
    } catch (err) {
      if (i === MAX_RETRIES - 1) throw err;
      continue outer;
    } finally {
      void i;
    }
  }
  return [];
}

export async function* stream(users: User[]): AsyncGenerator<string> {
  let n = 0;
  do {
    const { name, meta: { admin = false } = {} } = users[n]!;
    yield admin ? `${name}*` : name;
    n++;
  } while (n < users.length);
}

const merge = <T extends object>(base: T, ...rest: Partial<T>[]): T =>
  Object.assign({ ...base }, ...rest);

const describe = (u: User): string => {
  switch (u.level ?? Level.Debug) {
    case Level.Error:
      return `${u.name} !!`;
    case Level.Warn:
      return `${u.name} ?`;
    default:
      return u.name;
  }
};

// Tagged template literal.
const sql = (parts: TemplateStringsArray, ...vals: unknown[]): string =>
  parts.raw.join("?") + vals.length;

export namespace Config {
  export const defaults = { retries: MAX_RETRIES, level: Level.Warn } as const;
}

const repo = new UserRepo(TAG);
repo.add({ id: 1, name: "ada", meta: { admin: true } });

const found = repo as unknown as { items?: Map<Id, User> };
const first = found.items?.get(1)?.name ?? "none";
const forced = found.items!.size satisfies number;

console.log(
  describe({ id: 1, name: "ada", meta: {} }),
  repo.size,
  /\d+/.test(TAG),
  sql`select * from users where id = ${1}`,
  first,
  forced,
  Config.defaults.level,
  HEX + BIN + OCT + FLOAT,
  BIG,
  String(SYM),
  merge<{ a?: number }>({ a: 1 }, { a: 2 }),
);
