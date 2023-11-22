import '@testing-library/jest-dom';
import {render, screen} from '@testing-library/react';
import {Button} from '../../../components';

describe('Button', () => {
  it('should render button with text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('should render button with type button (as default)', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toHaveAttribute('type', 'button');
  });

  it('should render button with button type', () => {
    render(<Button type="button">Click me</Button>);
    expect(screen.getByText('Click me')).toHaveAttribute('type', 'button');
  });

  it('should render button with submit type', () => {
    render(<Button type="submit">Click me</Button>);
    expect(screen.getByText('Click me')).toHaveAttribute('type', 'submit');
  });

  it('should render button with reset type', () => {
    render(<Button type="reset">Click me</Button>);
    expect(screen.getByText('Click me')).toHaveAttribute('type', 'reset');
  });

  it('should render button with disabled attribute', () => {
    render(<Button disabled>Click me</Button>);
    expect(screen.getByText('Click me')).toBeDisabled();
  });

  it('should render button with theme primary (as default)', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toHaveClass('primary');
  });

  it('should render button with theme primary', () => {
    render(<Button theme="primary">Click me</Button>);
    expect(screen.getByText('Click me')).toHaveClass('primary');
  });

  it('should render button with theme secondary', () => {
    render(<Button theme="secondary">Click me</Button>);
    expect(screen.getByText('Click me')).toHaveClass('secondary');
  });

  it('should console.log("clicked") when button is clicked', () => {
    const spy = jest.spyOn(console, 'log');

    render(<Button onClick={() => console.log("clicked")}>Click me</Button>);
    screen.getByText('Click me').click();
    expect(spy).toHaveBeenCalledWith('clicked');
  });
});
