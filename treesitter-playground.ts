// 1. Primitives, literals, operators, and template strings
const appName: string = "Tree-sitter playground";
const version: number = 1.25;
const enabled: boolean = true;
const missing: undefined = undefined;
const empty: null = null;
const identifier: symbol = Symbol("identifier");
const largeInteger: bigint = 9007199254740993n;
let counter = 0;
let optionalMessage: string | undefined;
const hex = 0xff;
const binary = 0b101010;
const octal = 0o755;
const scientific = 6.022e23;
const separated = 1_000_000;
const escaped = "first\nsecond\tthird";
const quoted = 'He said "hello"';
const multiline = `First line
Second line
Third line`;
const greeting = `Welcome to ${appName}, v${version}`;
const expression = `${enabled ? "on" : "off"}: ${2 ** 8}`;
const pattern = /^(?<name>[a-z]+)-(?<id>\d+)$/gi;
const numbers: number[] = [1, 2, 3, 5, 8];
const labels: Array<string> = ["alpha", "beta", "gamma"];
const pair: [string, number] = ["score", 42];
const coordinates: readonly [number, number] = [10, 20];
const firstNumber = numbers[0] ?? 0;
const sum = numbers.reduce((total, value) => total + value, 0);
const doubled = numbers.map(value => value * 2);
const filtered = numbers.filter(value => value > 3);
const hasEven = numbers.some(value => value % 2 === 0);
const allPositive = numbers.every(value => value > 0);
const reversed = [...numbers].reverse();
const combined = [...numbers, ...doubled];
const [first, second, ...remaining] = combined;
counter += 1;
counter *= 2;
counter <<= 1;
counter ^= 3;
optionalMessage ??= "fallback";
const fallback = optionalMessage || "empty";
const logical = enabled && counter > 0;
const comparison = firstNumber === 1 && version !== 0;
const bitmask = (hex & binary) | octal;
const quotient = Math.floor(sum / numbers.length);
const remainder = sum % numbers.length;
const negative = -counter;
const inverted = ~bitmask;
console.log({ greeting, sum, pattern, logical });
// 2. Interfaces, unions, intersections, and enums
type EntityId = string | number;
type ThemeMode = "light" | "dark" | "system";
type Point = { x: number; y: number };
type Identified = { id: EntityId };
type Timestamped = { createdAt: Date; updatedAt?: Date };
type StoredPoint = Point & Identified & Timestamped;
interface Person {
  readonly id: EntityId;
  name: string;
  age?: number;
  address?: {
    city: string;
    country: string;
  };
}
interface Employee extends Person {
  department: string;
  salary: number;
}
interface Dictionary<T> {
  [key: string]: T;
}
interface Callable {
  (input: string): number;
  description?: string;
}
enum Priority {
  Low = 1,
  Normal,
  High,
}
enum Direction {
  Up = "UP",
  Down = "DOWN",
  Left = "LEFT",
  Right = "RIGHT",
}
const person: Person = {
  id: "person-1",
  name: "Ada",
  age: 36,
  address: { city: "London", country: "UK" },
};
const storedOrigin: StoredPoint = {
  id: 1, x: 0, y: 0, createdAt: new Date(),
};
const scores: Dictionary<number> = { ada: 100, grace: 98 };
const mode: ThemeMode = "dark";
console.log(person.address?.city, Priority.High, mode);
// 3. Functions, overloads, closures, and predicates
function add(left: number, right: number): number {
  return left + right;
}
function formatValue(value: string): string;
function formatValue(value: number): string;
function formatValue(value: string | number): string {
  return typeof value === "number" ? value.toFixed(2) : value.trim();
}
function total(...values: number[]): number {
  return values.reduce((result, value) => result + value, 0);
}
function greet(name: string, prefix = "Hello"): string {
  return `${prefix}, ${name}!`;
}
const multiply = (left: number, right: number): number => left * right;
const square = (value: number) => value ** 2;
const makeCounter = (initial = 0) => {
  let value = initial;
  return {
    increment: () => ++value,
    decrement: () => --value,
    current: () => value,
  };
};
function isPerson(value: unknown): value is Person {
  return typeof value === "object" && value !== null
    && "id" in value && "name" in value;
}
function assertDefined<T>(value: T): asserts value is NonNullable<T> {
  if (value === null || value === undefined) {
    throw new Error("Expected a defined value");
  }
}
function fail(message: string): never {
  throw new Error(message);
}
function withCallback(value: number, callback: (n: number) => void): void {
  callback(value);
}
function describePerson({ name, age = 0 }: Person): string {
  return `${name} is ${age} years old`;
}
const localCounter = makeCounter(10);
localCounter.increment();
withCallback(42, value => console.log(value));
const formattedNumber = formatValue(12.345);
const formattedText = formatValue("  hello  ");
const totalScore = total(10, 20, 30);
console.log(add(2, 3), square(4), describePerson(person));
// 4. Generics, constraints, conditional types, and mapped types
type Nullable<T> = T | null;
type Maybe<T> = T | undefined;
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };
type ElementOf<T> = T extends readonly (infer U)[] ? U : never;
type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;
type Mutable<T> = { -readonly [K in keyof T]: T[K] };
type Optional<T> = { [K in keyof T]?: T[K] };
type RequiredValues<T> = { [K in keyof T]-?: NonNullable<T[K]> };
type StringKeys<T> = Extract<keyof T, string>;
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];
};
type EventName = `user:${"created" | "updated" | "deleted"}`;
type PersonName = Pick<Person, "id" | "name">;
type PersonDetails = Omit<Person, "id">;
type PersonFields = keyof Person;
type PersonIdentifier = Person["id"];
function identity<T>(value: T): T {
  return value;
}
function firstItem<T>(items: readonly T[]): T | undefined {
  return items[0];
}
function propertyOf<T, K extends keyof T>(object: T, key: K): T[K] {
  return object[key];
}
function merge<A extends object, B extends object>(left: A, right: B): A & B {
  return { ...left, ...right };
}
function success<T>(value: T): Result<T> {
  return { ok: true, value };
}
function failure<E>(error: E): Result<never, E> {
  return { ok: false, error };
}
const immutableSettings = { mode: "dark", retries: 3 } as const;
const validatedSettings = {
  mode: "dark",
  retries: 3,
} satisfies { mode: ThemeMode; retries: number };
const personName = propertyOf(person, "name");
const mergedPoint = merge({ x: 1 }, { y: 2 });
const stringResult: Result<string> = success("ready");
const numberIdentity = identity<number>(42);
const firstLabel = firstItem(labels);
const eventName: EventName = "user:created";
console.log(personName, mergedPoint, eventName);
// 5. Classes, inheritance, accessors, and private fields
abstract class Shape {
  constructor(public readonly name: string) {}
  abstract area(): number;
  describe(): string {
    return `${this.name}: ${this.area()}`;
  }
}
class Rectangle extends Shape {
  static readonly kind = "rectangle";
  #scale = 1;
  constructor(private width: number, private height: number) {
    super("Rectangle");
  }
  get scale(): number {
    return this.#scale;
  }
  set scale(value: number) {
    if (value <= 0) throw new RangeError("Scale must be positive");
    this.#scale = value;
  }
  override area(): number {
    return this.width * this.height * this.#scale ** 2;
  }
  resize(width: number, height: number): this {
    this.width = width;
    this.height = height;
    return this;
  }
}
class Store<T extends Identified> {
  protected items = new Map<EntityId, T>();
  add(item: T): this {
    this.items.set(item.id, item);
    return this;
  }
  get(id: EntityId): T | undefined {
    return this.items.get(id);
  }
  get size(): number {
    return this.items.size;
  }
  values(): T[] {
    return [...this.items.values()];
  }
}
const rectangle = new Rectangle(10, 20);
rectangle.scale = 2;
const peopleStore = new Store<Person>().add(person);
console.log(rectangle.describe(), peopleStore.size);
// 6. Discriminated unions, narrowing, and exhaustive switches
type CircleShape = { kind: "circle"; radius: number };
type SquareShape = { kind: "square"; side: number };
type TriangleShape = { kind: "triangle"; base: number; height: number };
type Geometry = CircleShape | SquareShape | TriangleShape;
function assertNever(value: never): never {
  throw new Error(`Unexpected value: ${JSON.stringify(value)}`);
}
function geometryArea(shape: Geometry): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "square":
      return shape.side ** 2;
    case "triangle":
      return shape.base * shape.height / 2;
    default:
      return assertNever(shape);
  }
}
function inspectValue(value: unknown): string {
  if (typeof value === "string") {
    return value.toUpperCase();
  } else if (typeof value === "number") {
    return value.toFixed(3);
  } else if (value instanceof Date) {
    return value.toISOString();
  } else if (Array.isArray(value)) {
    return `Array(${value.length})`;
  } else if (isPerson(value)) {
    return value.name;
  }
  return String(value);
}
function unwrap<T>(result: Result<T>): T {
  if (result.ok) return result.value;
  throw result.error;
}
const shapes: Geometry[] = [
  { kind: "circle", radius: 5 },
  { kind: "square", side: 4 },
  { kind: "triangle", base: 6, height: 3 },
];
const areas = shapes.map(geometryArea);
const biggestArea = Math.max(...areas);
const inspected = ["hello", 42, new Date(), person].map(inspectValue);
const unwrapped = unwrap(success({ status: "ready" }));
const totalArea = areas.reduce((acc, area) => acc + area, 0);
console.log(biggestArea, totalArea, inspected);
console.log(unwrapped.status);
// 7. Async functions, promises, error handling, and generators
function delay(milliseconds: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, milliseconds));
}
async function computeLater(value: number): Promise<number> {
  await delay(10);
  return value * 2;
}
async function runTasks(values: number[]): Promise<Result<number[]>> {
  try {
    const results = await Promise.all(values.map(computeLater));
    return success(results);
  } catch (error: unknown) {
    return failure(error instanceof Error ? error : new Error(String(error)));
  } finally {
    console.log("Tasks finished");
  }
}
function* range(start: number, end: number, step = 1): Generator<number> {
  if (step <= 0) throw new RangeError("Step must be positive");
  for (let value = start; value < end; value += step) {
    yield value;
  }
}
function* fibonacci(limit: number): Generator<number> {
  let previous = 0;
  let current = 1;
  for (let index = 0; index < limit; index++) {
    yield previous;
    [previous, current] = [current, previous + current];
  }
}
async function* timedRange(count: number): AsyncGenerator<number> {
  for (let index = 0; index < count; index++) {
    await delay(5);
    yield index;
  }
}
async function consumeRange(): Promise<number[]> {
  const values: number[] = [];
  for await (const value of timedRange(3)) {
    values.push(value);
  }
  return values;
}
const rangeValues = [...range(0, 10, 2)];
const fibonacciValues = [...fibonacci(8)];
void runTasks([1, 2, 3]).then(result => console.log(result));
void consumeRange().then(values => console.log(values));
console.log(rangeValues, fibonacciValues);
// 8. Collections, iteration, destructuring, and control flow
const inventory = new Map<string, number>([
  ["apple", 3],
  ["pear", 5],
  ["orange", 2],
]);
const uniqueLabels = new Set(["alpha", "beta", "alpha"]);
const weakCache = new WeakMap<object, string>();
const cacheKey = { id: 1 };
weakCache.set(cacheKey, "cached value");
for (const [name, quantity] of inventory) {
  if (quantity < 3) continue;
  console.log(`${name}: ${quantity}`);
}
for (const label of uniqueLabels) {
  console.log(label.toUpperCase());
}
const settings = { theme: "dark", fontSize: 14, ligatures: false };
const { theme: selectedTheme, fontSize, ...otherSettings } = settings;
for (const key in otherSettings) {
  if (Object.prototype.hasOwnProperty.call(otherSettings, key)) {
    console.log(key);
  }
}
let attempts = 0;
while (attempts < 3) {
  attempts++;
}
do {
  attempts--;
} while (attempts > 0);
let located: number | undefined;
searchLoop:
for (let row = 0; row < 3; row++) {
  for (let column = 0; column < 3; column++) {
    if (row + column === 3) {
      located = row * 3 + column;
      break searchLoop;
    }
  }
}
const entries = Object.entries(settings);
const reconstructed = Object.fromEntries(entries);
const flatValues = [[1, 2], [3, 4]].flat();
const flatMapped = flatValues.flatMap(value => [value, -value]);
const sortedValues = [...flatMapped].sort((a, b) => a - b);
const inventoryTotal = [...inventory.values()].reduce((a, b) => a + b, 0);
console.log(selectedTheme, fontSize, located);
console.log(reconstructed, sortedValues, inventoryTotal);
console.log(weakCache.get(cacheKey));
// 9. Typed events, generic methods, and indexed access
interface AppEvents {
  ready: { timestamp: number };
  message: { text: string; sender: Person };
  error: { message: string; recoverable: boolean };
}
type EventHandler<T> = (payload: T) => void;
class EventBus<Events extends object> {
  private listeners: {
    [K in keyof Events]?: Set<EventHandler<Events[K]>>;
  } = {};
  on<K extends keyof Events>(event: K, handler: EventHandler<Events[K]>): () => void {
    const handlers = this.listeners[event] ??= new Set<EventHandler<Events[K]>>();
    handlers.add(handler);
    return () => {
      handlers.delete(handler);
    };
  }
  emit<K extends keyof Events>(event: K, payload: Events[K]): void {
    this.listeners[event]?.forEach(handler => handler(payload));
  }
  clear<K extends keyof Events>(event: K): void {
    this.listeners[event]?.clear();
  }
}
const bus = new EventBus<AppEvents>();
const stopMessages = bus.on("message", ({ text, sender }) => {
  console.log(`${sender.name}: ${text}`);
});
bus.on("ready", ({ timestamp }) => {
  console.log(`Ready at ${new Date(timestamp).toISOString()}`);
});
bus.on("error", ({ message, recoverable }) => {
  console.log(recoverable ? "Warning" : "Failure", message);
});
bus.emit("ready", { timestamp: Date.now() });
bus.emit("message", { text: "Hello from TypeScript", sender: person });
stopMessages();
bus.clear("message");
type HandlerMap = {
  [K in keyof AppEvents]: EventHandler<AppEvents[K]>;
};
const handlers: HandlerMap = {
  ready: payload => console.log(payload.timestamp),
  message: payload => console.log(payload.text),
  error: payload => console.log(payload.message),
};
handlers.ready({ timestamp: 0 });
handlers.message({ text: "A typed event", sender: person });
handlers.error({ message: "Example warning", recoverable: true });
// 10. Recursive structures, algorithms, and documentation comments
interface TreeNode<T> {
  value: T;
  children: TreeNode<T>[];
}
/** Visit a tree in depth-first order. */
function visitTree<T>(node: TreeNode<T>, visit: (value: T) => void): void {
  visit(node.value);
  for (const child of node.children) {
    visitTree(child, visit);
  }
}
function mapTree<A, B>(node: TreeNode<A>, transform: (value: A) => B): TreeNode<B> {
  return {
    value: transform(node.value),
    children: node.children.map(child => mapTree(child, transform)),
  };
}
function treeDepth<T>(node: TreeNode<T>): number {
  return 1 + Math.max(0, ...node.children.map(treeDepth));
}
const tree: TreeNode<string> = {
  value: "root",
  children: [
    { value: "left", children: [] },
    { value: "right", children: [
      { value: "leaf", children: [] },
    ] },
  ],
};
const uppercaseTree = mapTree(tree, value => value.toUpperCase());
const visitedNodes: string[] = [];
visitTree(uppercaseTree, value => visitedNodes.push(value));
function binarySearch(values: readonly number[], target: number): number {
  let low = 0;
  let high = values.length - 1;
  while (low <= high) {
    const middle = Math.floor((low + high) / 2);
    const value = values[middle]!;
    if (value === target) return middle;
    if (value < target) low = middle + 1;
    else high = middle - 1;
  }
  return -1;
}
const foundIndex = binarySearch([1, 3, 5, 7, 9], 7);
console.log({ depth: treeDepth(tree), visitedNodes, foundIndex });
// TODO: Try changing these colors in your theme.
// NOTE: Unused declarations may receive diagnostic highlights.
// End of the TypeScript highlight playground.
