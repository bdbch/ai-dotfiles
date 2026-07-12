---
name: "shopify-development"
description: "Build Shopify apps, themes, and custom storefronts — GraphQL Admin API, REST API, Liquid templating, Hydrogen, App Bridge, webhooks, checkout extensibility, Polaris components, and Shopify CLI."
---

# Shopify Development

> Build Shopify apps, themes, and custom storefronts — GraphQL Admin API, REST API, Liquid templating, Hydrogen, App Bridge, webhooks, checkout extensibility, Polaris components, and Shopify CLI.

## When to use

Use this skill when working with Shopify: building custom or public apps, developing Liquid themes, integrating with the Shopify Admin API or Storefront API, creating Hydrogen storefronts, implementing checkout extensions, working with webhooks, or using Shopify CLI.

## Core architecture

- **Shopify is a platform, not just a store** — It provides APIs for every part of commerce: products, orders, inventory, customers, shipping, payments, discounts, and more.
- **Three extension paths**: Apps (backend integrations), Themes (storefront appearance), and Custom Storefronts (headless via Hydrogen).
- **Admin API is the core** — The GraphQL Admin API is the primary way to read and write shop data. REST API is legacy but still widely used.
- **App architecture**: Apps run on your own infrastructure and communicate with Shopify via OAuth 2.0, webhooks, and APIs. Apps can embed in the Shopify admin via App Bridge.
- **Theme architecture**: Themes use Liquid templating, JSON templates, and sections. They're uploaded as .zip files or connected via Shopify CLI.
- **Hydrogen is React-based**: Hydrogen is Shopify's React framework for headless commerce, built on Remix.

## Shopify CLI

```bash
# Install
npm i -g @shopify/cli@latest

# Create a new app
shopify app init

# Create a new theme (clones Dawn)
shopify theme init

# Create a Hydrogen storefront
shopify hydrogen init

# Development
shopify app dev       # Start app development server with ngrok tunnel
shopify theme dev     # Watch and sync theme changes
shopify hydrogen dev  # Start Hydrogen dev server

# Build & deploy
shopify app build
shopify app deploy
shopify theme push
```

## App development

### App types

| Type | Description |
|------|-------------|
| **Public app** | Listed on the Shopify App Store. Installed by any merchant. |
| **Custom app** | Built for a single merchant's store. Not listed on the App Store. |
| **Sales channel** | Integrates as a sales channel in the Shopify admin (e.g., TikTok, Amazon). |
| **Checkout extension** | Extends Shopify Checkout with custom UI using UI extensions. |

### OAuth 2.0 flow

```javascript
// 1. Redirect merchant to Shopify authorization
const redirectUrl = `https://${shop}.myshopify.com/admin/oauth/authorize` +
  `?client_id=${API_KEY}` +
  `&scope=${SCOPES}` +
  `&redirect_uri=${REDIRECT_URI}` +
  `&state=${NONCE}`;

// 2. Handle OAuth callback
app.get('/callback', async (req, res) => {
  const { shop, code, state } = req.query;

  // Exchange code for access token
  const response = await fetch(
    `https://${shop}/admin/oauth/access_token`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        client_id: API_KEY,
        client_secret: API_SECRET,
        code,
      }),
    }
  );

  const { access_token } = await response.json();
  // Store access_token securely with the shop name
});
```

### Shopify API library (recommended)

```javascript
import '@shopify/shopify-api/adapters/node';
import { shopifyApi, ApiVersion, Session } from '@shopify/shopify-api';

const shopify = shopifyApi({
  apiKey: 'YOUR_API_KEY',
  apiSecretKey: 'YOUR_API_SECRET',
  scopes: ['read_products', 'write_products'],
  hostName: 'your-app.com',
  apiVersion: ApiVersion.October24,
  isEmbeddedApp: true,
  sessionStorage: new shopify.session.CustomSessionStorage(
    storeCallback, loadCallback, deleteCallback
  ),
});

// REST API
const session = await shopify.session.getCurrentSession({ isOnline: true });
const client = new shopify.clients.Rest({ session });
const products = await client.get({ path: 'products' });

// GraphQL Admin API
const graphqlClient = new shopify.clients.Graphql({ session });
const response = await graphqlClient.query({
  data: {
    query: `#graphql
      query {
        products(first: 10) {
          nodes {
            id
            title
            variants(first: 5) {
              nodes { id price }
            }
          }
        }
      }
    `,
  },
});
```

### GraphQL Admin API

```graphql
# Products
query GetProducts($first: Int!) {
  products(first: $first) {
    nodes {
      id
      title
      description
      status
      variants(first: 5) {
        nodes { id price inventoryQuantity }
      }
    }
  }
}

mutation CreateProduct($input: ProductInput!) {
  productCreate(input: $input) {
    product { id title }
    userErrors { field message }
  }
}

mutation UpdateInventory($input: InventoryAdjustQuantityInput!) {
  inventoryAdjustQuantity(input: $input) {
    inventoryLevel { id available }
    userErrors { field message }
  }
}

# Orders
query GetOrder($id: ID!) {
  order(id: $id) {
    id name
    displayFinancialStatus
    displayFulfillmentStatus
    totalPriceSet { shopMoney { amount currencyCode } }
    lineItems(first: 10) {
      nodes {
        title quantity
        variant { id sku }
      }
    }
    customer { id firstName lastName email }
  }
}

# Customers
mutation CreateCustomer($input: CustomerInput!) {
  customerCreate(input: $input) {
    customer { id email }
    userErrors { field message }
  }
}
```

### GraphQL Storefront API

```graphql
# Requires a Storefront Access Token (public, can be exposed)
query GetProducts($first: Int!) {
  products(first: $first) {
    nodes {
      id
      title
      availableForSale
      compareAtPriceRange { minVariantPrice { amount currencyCode } }
      priceRange { minVariantPrice { amount currencyCode } }
      images(first: 1) { nodes { url altText } }
    }
  }
}

mutation CreateCart($input: CartInput!) {
  cartCreate(input: $input) {
    cart { id checkoutUrl totalQuantity }
  }
}

mutation CartLinesAdd($cartId: ID!, $lines: [CartLineInput!]!) {
  cartLinesAdd(cartId: $cartId, lines: $lines) {
    cart { id totalQuantity }
  }
}
```

### REST API (legacy, still in wide use)

```javascript
// GET /admin/api/2024-10/products.json
// POST /admin/api/2024-10/products.json
// PUT /admin/api/2024-10/products/{id}.json
// DELETE /admin/api/2024-10/products/{id}.json

const response = await fetch(
  `https://${shop}.myshopify.com/admin/api/2024-10/products.json`, {
    headers: {
      'X-Shopify-Access-Token': ACCESS_TOKEN,
      'Content-Type': 'application/json',
    },
  }
);
```

### App Bridge (embedded apps)

```javascript
import { createApp } from '@shopify/app-bridge';
import { getSessionToken } from '@shopify/app-bridge-utils';
import { Redirect } from '@shopify/app-bridge/actions';

const app = createApp({
  apiKey: 'YOUR_API_KEY',
  host: new URLSearchParams(location.search).get('host'),
  forceRedirect: true,
});

// Redirect
const redirect = Redirect.create(app);
redirect.dispatch(Redirect.Action.APP, '/my-page');

// Get session token for API calls
const token = await getSessionToken(app);
// Use token in Authorization header for your backend
```

### App Bridge UI components

```javascript
import { TitleBar, Toast, Modal, Loading } from '@shopify/app-bridge/actions';

// Title bar
const titleBar = TitleBar.create(app, { title: 'My Page' });

// Toast notifications
const toast = Toast.create(app, { message: 'Saved!', duration: 3000 });
toast.dispatch(Toast.Action.SHOW);

// Modal
const modal = Modal.create(app, { title: 'Confirm', message: 'Are you sure?' });
modal.dispatch(Modal.Action.OPEN);
```

### Polaris (React component library)

```jsx
import { Page, Card, DataTable, Button, TextField, Banner } from '@shopify/polaris';
import '@shopify/polaris/build/esm/styles.css';

export default function App() {
  const [value, setValue] = useState('');

  return (
    <Page title="My App">
      <Card>
        <TextField
          label="Product Title"
          value={value}
          onChange={setValue}
          autoComplete="off"
        />
        <Button variant="primary" onClick={handleSave}>Save</Button>
      </Card>
    </Page>
  );
}
```

## Webhooks

```javascript
// Topics: products/create, orders/paid, app/uninstalled, etc.
// Register in app setup:

const webhookRegistry = {
  PRODUCTS_CREATE: '/webhooks/products/create',
  ORDERS_PAID: '/webhooks/orders/paid',
  APP_UNINSTALLED: '/webhooks/app/uninstalled',
};

// Handle webhook (verify HMAC signature)
app.post('/webhooks/products/create', async (req, res) => {
  const isValid = shopify.webhooks.validate({
    rawBody: req.body,
    rawRequest: req,
    rawResponse: res,
  });

  if (!isValid) return res.status(401).send('Invalid HMAC');

  const product = req.body;
  // Process product creation
  res.status(200).end();
});

// GraphQL mutation to register webhooks
mutation WebhookSubscriptionCreate($topic: WebhookSubscriptionTopic!, $callbackUrl: URL!) {
  webhookSubscriptionCreate(topic: $topic, webhookSubscription: { callbackUrl: $callbackUrl }) {
    webhookSubscription { id }
    userErrors { field message }
  }
}
```

## Checkout extensibility

Shopify's new checkout uses UI extensions (not the legacy `checkout.liquid`).

```javascript
// checkout-ui-extension/main.jsx
import { reactExtension, BlockStack, Text, Button } from '@shopify/ui-extensions-react/checkout';

export default reactExtension('purchase.checkout.block.render', () => <Extension />);

function Extension() {
  const { applyCartChanges } = useApplyCartChanges();
  const [loading, setLoading] = useState(false);

  const addUpsell = async () => {
    setLoading(true);
    await applyCartChanges([{ quantity: 1, merchandiseId: 'gid://shopify/ProductVariant/123' }]);
    setLoading(false);
  };

  return (
    <BlockStack>
      <Text size="large">Want fries with that?</Text>
      <Button loading={loading} onPress={addUpsell}>Add for $2.99</Button>
    </BlockStack>
  );
}
```

### Extension target points

| Target | Location |
|--------|----------|
| `purchase.checkout.block.render` | Main checkout block |
| `purchase.checkout.cart-line-list.render-after` | After cart lines |
| `purchase.checkout.shipping-option-list.render-before` | Before shipping options |
| `purchase.checkout.payment-method-list.render-after` | After payment methods |
| `purchase.checkout.header.render-after` | After checkout header |
| `purchase.thank-you.cart-line-list.render-after` | Post-purchase thank you page |
| `purchase.thank-you.order-status.render` | Order status page |

## Theme development

### Liquid basics

```liquid
{% comment %} Output {% endcomment %}
{{ product.title }}
{{ 'hello' | upcase }}
{{ price | money }}

{% comment %} Logic {% endcomment %}
{% if product.available %}
  <button>Add to cart</button>
{% else %}
  <p>Sold out</p>
{% endif %}

{% comment %} Loops {% endcomment %}
{% for product in collections.all.products limit: 10 %}
  <a href="{{ product.url }}">{{ product.title }}</a>
{% endfor %}

{% comment %} Theme settings {% endcomment %}
{{ settings.color_primary }}
{{ section.settings.heading_size }}
```

### JSON templates (OS 2.0+)

```json
// templates/index.json
{
  "sections": {
    "hero": {
      "type": "hero-banner",
      "settings": {
        "heading": "Welcome",
        "background_color": "#f5f5f5"
      }
    },
    "featured-collection": {
      "type": "featured-collection",
      "settings": {
        "collection": "frontpage",
        "products_to_show": 8
      }
    }
  },
  "order": ["hero", "featured-collection"]
}
```

### Theme schema

```liquid
{% schema %}
{
  "name": "Featured Collection",
  "settings": [
    {
      "type": "collection",
      "id": "collection",
      "label": "Collection"
    },
    {
      "type": "range",
      "id": "products_to_show",
      "min": 4,
      "max": 24,
      "step": 4,
      "default": 8,
      "label": "Products to show"
    }
  ],
  "presets": [
    {
      "name": "Featured Collection",
      "settings": {
        "products_to_show": 8
      }
    }
  ]
}
{% endschema %}
```

### Theme app extensions

Extend themes with app blocks (Liquid, JS, CSS):

```liquid
{% comment %} blocks/my-app-block.liquid {% endcomment %}
<div class="my-app-widget">
  <h3>{{ block.settings.heading }}</h3>
  <div id="my-app-root" data-product="{{ product.id }}"></div>
</div>

{% schema %}
{
  "name": "My App Widget",
  "target": "section",
  "settings": [
    { "type": "text", "id": "heading", "label": "Heading", "default": "My App" }
  ]
}
{% endschema %}
```

## Hydrogen (headless storefront)

Hydrogen is Shopify's React-based framework for building custom storefronts, built on Remix.

```jsx
// app/routes/products.$handle.jsx
import { useLoaderData } from '@remix-run/react';
import { json } from '@shopify/remix-oxygen';

export async function loader({ params, context }) {
  const { product } = await context.storefront.query(PRODUCT_QUERY, {
    variables: { handle: params.handle },
  });
  return json({ product });
}

export default function Product() {
  const { product } = useLoaderData();

  return (
    <div>
      <h1>{product.title}</h1>
      <p>{product.description}</p>
      <p>{product.priceRange.minVariantPrice.amount}</p>
    </div>
  );
}

const PRODUCT_QUERY = `#graphql
  query Product($handle: String!) {
    product(handle: $handle) {
      id title description
      priceRange {
        minVariantPrice { amount currencyCode }
      }
      images(first: 5) { nodes { url altText } }
    }
  }
`;
```

### Hydrogen components

```jsx
import {
  CartProvider,
  CartCheckoutButton,
  CartLineQuantity,
  CartLineQuantityAdjustButton,
  Money,
  ShopPayButton,
  VariantSelector,
  Image,
  Link,
  Seo,
} from '@shopify/hydrogen';

<CartProvider>
  <Seo type="product" data={product} />
  <Image data={product.images.nodes[0]} />
  <VariantSelector handle={product.handle} options={product.options}>
    {({ option }) => <button>{option.value}</button>}
  </VariantSelector>
  <Money data={product.priceRange.minVariantPrice} />
  <ShopPayButton variantIds={[selectedVariant.id]} />
</CartProvider>
```

## Shopify Functions

Server-side logic for discounts, shipping, payments, and order routing, running on Shopify's infrastructure.

```javascript
// extensions/discount-function/main.js
export default function discount(input) {
  const { cart, discountNode } = input;
  const eligibleItems = cart.lines.filter(line => line.quantity >= 2);

  return {
    discounts: eligibleItems.map(line => ({
      message: 'Buy 2+ get 10% off',
      targets: [{
        productVariant: { id: line.merchandiseId },
        quantity: line.quantity,
      }],
      value: {
        percentage: { value: 10 },
      },
    })),
  };
}
```

### Function types

| Type | Use case |
|------|----------|
| `discounts` | Custom discount logic |
| `shipping` | Custom shipping rates (by weight, location, etc.) |
| `payment` | Custom payment gateways |
| `order-routing` | Custom fulfillment location selection |
| `delivery-customization` | Custom delivery options |

## Common patterns

### Shopify session handling

```javascript
// Middleware for validating Shopify sessions
app.use('/api/*', async (req, res, next) => {
  const session = await shopify.session.getCurrentSession({
    isOnline: true,
    rawRequest: req,
    rawResponse: res,
  });

  if (!session) {
    return res.redirect(`/auth?shop=${req.query.shop}`);
  }

  res.locals.session = session;
  next();
});
```

### Billing

```javascript
// Create a one-time charge
const response = await graphqlClient.query({
  data: {
    query: `mutation {
      appPurchaseOneTimeCreate(
        name: "Premium Plan",
        price: { amount: 9.99, currencyCode: USD },
        returnUrl: "https://example.com/billing/done"
      ) { ... }
    }`,
  },
});
```

### GDPR webhooks

```javascript
// Required for public apps on App Store
// customers/data_request — Export customer data
// customers/redact — Delete customer data
// shop/redact — Delete shop data
```

## Pitfalls & gotchas

- **API rate limits**: GraphQL Admin API: 1,000 cost points per second per shop. REST: 40 requests per second per shop. Use `Cost` field in GraphQL to plan queries.
- **OAuth sessions are not persisted by default**: Use `CustomSessionStorage` to save sessions to your database.
- **Session tokens vs API tokens**: Embedded apps use short-lived session tokens (JWT). Custom apps use long-lived access tokens.
- **CORS in embedded apps**: The App Bridge handles this. Your app doesn't need CORS headers for embedded apps.
- **Liquid is not JavaScript**: Logic is limited. Complex behavior needs app extensions or custom sections with JS.
- **GraphQL pagination**: Use `first`/`last` with `after`/`before` cursors. Always paginate with `pageInfo { hasNextPage endCursor }`.
- **Webhook HMAC verification**: Always verify HMAC signatures on webhooks. Shopify signs the raw body with your API secret.
- **Checkout extensibility vs checkout.liquid**: Legacy `checkout.liquid` themes are deprecated. New checkout uses UI extensions only.
- **Hydrogen vs Online Store 2.0**: Hydrogen is for fully headless sites. Online Store 2.0 themes use Liquid and run on Shopify's servers.
- **App Store review**: Public apps require a thorough review process. Plan for it: test with Edge cases, handle errors gracefully, provide support contact.
- **Scopes cannot be reduced**: Once a merchant installs with certain scopes, you can't require fewer scopes without reinstalling.
- **`X-Shopify-Shop-Domain` header**: In embedded apps, use the `host` query param (base64 encoded) to determine the shop, not HTTP headers.

## Reference

- [Shopify Dev Docs](https://developer.shopify.com/docs)
- [Shopify GraphQL Admin API](https://shopify.dev/docs/api/admin-graphql)
- [Shopify Storefront API](https://shopify.dev/docs/api/storefront-graphql)
- [Shopify CLI](https://shopify.dev/docs/api/shopify-cli)
- [Shopify Polaris](https://polaris.shopify.com/)
- [Shopify Hydrogen](https://shopify.dev/docs/api/hydrogen)
- [Shopify App Bridge](https://shopify.dev/docs/api/app-bridge)
- [Shopify Theme Dev](https://shopify.dev/docs/themes)
- [Shopify App Store Requirements](https://shopify.dev/docs/apps/store/requirements)
- [Shopify Developer Changelog](https://shopify.dev/changelog)
