import '@testing-library/jest-dom';
import {render, fireEvent} from '@testing-library/react';
import {Input} from '../../../components';

describe('Input component', () => {
  it('renders without errors', () => {
    const { getByTestId } = render(
      <Input
        data-testid="input-component"
        value=""
        onChange={() => {}}
      />
    );
    const inputComponent = getByTestId('input-component');

    expect(inputComponent).toBeTruthy();
  });

  it('displays the label when provided', () => {
    const labelText = 'Test Label';
    const { getByText } = render(
      <Input
        label={labelText}
        value=""
        onChange={() => {}}
      />
    );
    const label = getByText(labelText);

    expect(label).toBeInTheDocument();
  });

  it('toggles password visibility when the toggle button is clicked', () => {
    const { getByRole, getByTestId } = render(
      <Input
        data-testid="input-component"
        type="password"
        value="password123"
        onChange={() => {}}
      />
    );
    const input = getByTestId('input-component');
    const toggleButton = getByRole('button');

    expect(input).toHaveAttribute('type', 'password');
    fireEvent.click(toggleButton);
    expect(input).toHaveAttribute('type', 'text');
    fireEvent.click(toggleButton);
    expect(input).toHaveAttribute('type', 'password');
  });

  it('calls the onChange function when input value changes', () => {
    const mockOnChange = jest.fn();
    const { getByTestId } = render(
      <Input
        data-testid="input-component"
        value=""
        onChange={mockOnChange}
      />
    );
    const input = getByTestId('input-component');

    fireEvent.change(input, { target: { value: 'New value' } });
    expect(mockOnChange).toHaveBeenCalledWith('New value')
  });

  it('displays error message when error prop is provided', () => {
    const errorMessage = 'Invalid input';
    const { getByText } = render(
      <Input
        error={errorMessage}
        value=""
        onChange={() => {}}
      />
    );
    const errorSpan = getByText(errorMessage);

    expect(errorSpan).toBeInTheDocument();
  });

  it('displays bottom content when bottomContent prop is provided', () => {
    const bottomContentText = 'Additional information';
    const { getByText } = render(
      <Input
        bottomContent={bottomContentText}
        value=""
        onChange={() => {}}
      />
    );
    const bottomContent = getByText(bottomContentText);

    expect(bottomContent).toBeInTheDocument();
  });

  it('displays the input value when provided', () => {
    const inputValue = 'Test Input';
    const {getByDisplayValue} = render(
      <Input
        value={inputValue}
        onChange={() => {
        }}
      />
    );
    const input = getByDisplayValue(inputValue);

    expect(input).toBeInTheDocument();
  });
});
